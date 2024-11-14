#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#endif

#include <string>
#include <iostream>
#include <filesystem>

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
  FlMethodChannel* storage_channel;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

// Argument keys
auto kFilePathKey = "filePath";
auto kFileNameKey = "fileName";
auto kMimeTypeKey = "mimeType";

void create_file(const char * file_path, const char * file_name);

static void storage_method_call_handler (FlMethodChannel* channel, FlMethodCall* method_call, gpointer user_data) {
  g_autoptr(FlMethodResponse) response = nullptr;
  if (strcmp(fl_method_call_get_name(method_call), "saveFile") == 0) {
    if (FlValue* args = fl_method_call_get_args(method_call); args != nullptr) {
      const char* file_path = nullptr;
      const char* file_name = nullptr;

      if (FlValue* file_path_value = fl_value_lookup_string(args, kFilePathKey); file_path_value != nullptr) {
        file_path = fl_value_get_string(file_path_value);
      }

      if (FlValue* file_name_value = fl_value_lookup_string(args, kFileNameKey); file_name_value != nullptr) {
        file_name = fl_value_get_string(file_name_value);
      }

      if (file_path != nullptr && file_name != nullptr) {
        create_file(file_path, file_name);
      }
    }

    g_autoptr(FlValue) result = fl_value_new_int(0);
    response = FL_METHOD_RESPONSE(fl_method_success_response_new(result));
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  g_autoptr(GError) error = nullptr;
  if (!fl_method_call_respond(method_call, response, &error)) {
    g_warning("Failed to send response: %s", error->message);
  }
}

void create_file(const char* file_path, const char* file_name) {
  GtkWidget *dialog = gtk_file_chooser_dialog_new("Save File", nullptr, GTK_FILE_CHOOSER_ACTION_SAVE, "Cancel", GTK_RESPONSE_CANCEL, "Save", GTK_RESPONSE_ACCEPT, NULL);

  gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER(dialog), file_name);
  gtk_widget_show_all(dialog);

  if (gint response = gtk_dialog_run(GTK_DIALOG(dialog)); response == GTK_RESPONSE_ACCEPT) {
    gchar *dest_file_path = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dialog));

    try {
      std::filesystem::copy(file_path, dest_file_path);
      std::remove(file_path);
    } catch (std::filesystem::filesystem_error& e) {
      std::cout << e.what() << '\n';
    }

    g_free(dest_file_path);
  }
  gtk_widget_destroy(dialog);
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  } else {
    // Checks if Hyprland is used
    if (FILE *fp = popen("printenv HYPRLAND_INSTANCE_SIGNATURE", "r"); fp == nullptr) {
      perror("popen failed");
      use_header_bar = true;
    } else {
      if (char buffer[128]; fgets(buffer, sizeof(buffer), fp) != nullptr) {
        buffer[strcspn(buffer, "\n")] = 0;
        if (strlen(buffer) > 0) {
          use_header_bar = false;
        }
      }
      pclose(fp);
    }
  }

#endif
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, "app");
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, "app");
  }

  gtk_window_set_default_size(window, 1280, 720);
  gtk_widget_show(GTK_WIDGET(window));

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  // Set channel
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->storage_channel = fl_method_channel_new(
      fl_engine_get_binary_messenger(fl_view_get_engine(view)),
      "io.github.lanis-mobile/storage", FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(
      self->storage_channel, storage_method_call_handler, self, nullptr);

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application, gchar*** arguments, int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
     g_warning("Failed to register: %s", error->message);
     *exit_status = 1;
     return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GApplication::startup.
static void my_application_startup(GApplication* application) {
  //MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication* application) {
  //MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  g_clear_object(&self->storage_channel);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line = my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID,
                                     "flags", G_APPLICATION_NON_UNIQUE,
                                     nullptr));
}
