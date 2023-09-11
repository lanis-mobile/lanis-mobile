"use strict";
var __create = Object.create;
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getProtoOf = Object.getPrototypeOf;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __defNormalProp = (obj, key, value) => key in obj ? __defProp(obj, key, { enumerable: true, configurable: true, writable: true, value }) : obj[key] = value;
var __commonJS = (cb, mod) => function __require() {
  return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
};
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, { get: all[name], enumerable: true });
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
  // If the importer is in node compatibility mode or this is not an ESM
  // file that has been converted to a CommonJS file using a Babel-
  // compatible transform (i.e. "__esModule" has not been set), then set
  // "default" to the CommonJS "module.exports" for node compatibility.
  isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
  mod
));
var __toCommonJS = (mod) => __copyProps(__defProp({}, "__esModule", { value: true }), mod);
var __decorateClass = (decorators, target, key, kind) => {
  var result = kind > 1 ? void 0 : kind ? __getOwnPropDesc(target, key) : target;
  for (var i = decorators.length - 1, decorator; i >= 0; i--)
    if (decorator = decorators[i])
      result = (kind ? decorator(target, key, result) : decorator(result)) || result;
  if (kind && result)
    __defProp(target, key, result);
  return result;
};
var __publicField = (obj, key, value) => {
  __defNormalProp(obj, typeof key !== "symbol" ? key + "" : key, value);
  return value;
};
var __accessCheck = (obj, member, msg) => {
  if (!member.has(obj))
    throw TypeError("Cannot " + msg);
};
var __privateGet = (obj, member, getter) => {
  __accessCheck(obj, member, "read from private field");
  return getter ? getter.call(obj) : member.get(obj);
};
var __privateAdd = (obj, member, value) => {
  if (member.has(obj))
    throw TypeError("Cannot add the same private member more than once");
  member instanceof WeakSet ? member.add(obj) : member.set(obj, value);
};
var __privateSet = (obj, member, value, setter) => {
  __accessCheck(obj, member, "write to private field");
  setter ? setter.call(obj, value) : member.set(obj, value);
  return value;
};
var __privateMethod = (obj, member, method) => {
  __accessCheck(obj, member, "access private method");
  return method;
};

// packages/miniflare/src/runtime/config/workerd.capnp.js
var require_workerd_capnp = __commonJS({
  "packages/miniflare/src/runtime/config/workerd.capnp.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.Extension = exports.Extension_Module = exports.TlsOptions = exports.TlsOptions_Version = exports.TlsOptions_Keypair = exports.HttpOptions = exports.HttpOptions_Header = exports.HttpOptions_Style = exports.DiskDirectory = exports.Network = exports.ExternalServer = exports.ExternalServer_Which = exports.ExternalServer_Https = exports.Worker = exports.Worker_Which = exports.Worker_DurableObjectStorage = exports.Worker_DurableObjectStorage_Which = exports.Worker_DurableObjectNamespace = exports.Worker_DurableObjectNamespace_Which = exports.Worker_Binding = exports.Worker_Binding_Which = exports.Worker_Binding_Parameter = exports.Worker_Binding_WrappedBinding = exports.Worker_Binding_CryptoKey = exports.Worker_Binding_CryptoKey_Which = exports.Worker_Binding_CryptoKey_Algorithm = exports.Worker_Binding_CryptoKey_Algorithm_Which = exports.Worker_Binding_CryptoKey_Usage = exports.Worker_Binding_DurableObjectNamespaceDesignator = exports.Worker_Binding_Type = exports.Worker_Binding_Type_Which = exports.Worker_Module = exports.Worker_Module_Which = exports.ServiceDesignator = exports.Service = exports.Service_Which = exports.Socket = exports.Socket_Which = exports.Socket_Https = exports.Config = exports._capnpFileId = void 0;
    var capnp = require("capnp-ts");
    var capnp_ts_1 = require("capnp-ts");
    exports._capnpFileId = "e6afd26682091c01";
    var Config3 = class extends capnp_ts_1.Struct {
      adoptServices(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      disownServices() {
        return capnp_ts_1.Struct.disown(this.getServices());
      }
      getServices() {
        return capnp_ts_1.Struct.getList(0, Config3._Services, this);
      }
      hasServices() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(0, this));
      }
      initServices(length) {
        return capnp_ts_1.Struct.initList(0, Config3._Services, length, this);
      }
      setServices(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      adoptSockets(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownSockets() {
        return capnp_ts_1.Struct.disown(this.getSockets());
      }
      getSockets() {
        return capnp_ts_1.Struct.getList(1, Config3._Sockets, this);
      }
      hasSockets() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initSockets(length) {
        return capnp_ts_1.Struct.initList(1, Config3._Sockets, length, this);
      }
      setSockets(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptV8Flags(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      disownV8Flags() {
        return capnp_ts_1.Struct.disown(this.getV8Flags());
      }
      getV8Flags() {
        return capnp_ts_1.Struct.getList(2, capnp.TextList, this);
      }
      hasV8Flags() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(2, this));
      }
      initV8Flags(length) {
        return capnp_ts_1.Struct.initList(2, capnp.TextList, length, this);
      }
      setV8Flags(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      adoptExtensions(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(3, this));
      }
      disownExtensions() {
        return capnp_ts_1.Struct.disown(this.getExtensions());
      }
      getExtensions() {
        return capnp_ts_1.Struct.getList(3, Config3._Extensions, this);
      }
      hasExtensions() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(3, this));
      }
      initExtensions(length) {
        return capnp_ts_1.Struct.initList(3, Config3._Extensions, length, this);
      }
      setExtensions(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(3, this));
      }
      toString() {
        return "Config_" + super.toString();
      }
    };
    exports.Config = Config3;
    Config3._capnp = { displayName: "Config", id: "8794486c76aaa7d6", size: new capnp_ts_1.ObjectSize(0, 4) };
    var Socket_Https = class extends capnp_ts_1.Struct {
      adoptOptions(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      disownOptions() {
        return capnp_ts_1.Struct.disown(this.getOptions());
      }
      getOptions() {
        return capnp_ts_1.Struct.getStruct(2, HttpOptions, this);
      }
      hasOptions() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(2, this));
      }
      initOptions() {
        return capnp_ts_1.Struct.initStructAt(2, HttpOptions, this);
      }
      setOptions(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      adoptTlsOptions(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(3, this));
      }
      disownTlsOptions() {
        return capnp_ts_1.Struct.disown(this.getTlsOptions());
      }
      getTlsOptions() {
        return capnp_ts_1.Struct.getStruct(3, TlsOptions, this);
      }
      hasTlsOptions() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(3, this));
      }
      initTlsOptions() {
        return capnp_ts_1.Struct.initStructAt(3, TlsOptions, this);
      }
      setTlsOptions(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(3, this));
      }
      toString() {
        return "Socket_Https_" + super.toString();
      }
    };
    exports.Socket_Https = Socket_Https;
    Socket_Https._capnp = { displayName: "https", id: "de123876383cbbdc", size: new capnp_ts_1.ObjectSize(8, 5) };
    var Socket_Which;
    (function(Socket_Which2) {
      Socket_Which2[Socket_Which2["HTTP"] = 0] = "HTTP";
      Socket_Which2[Socket_Which2["HTTPS"] = 1] = "HTTPS";
    })(Socket_Which = exports.Socket_Which || (exports.Socket_Which = {}));
    var Socket2 = class extends capnp_ts_1.Struct {
      getName() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setName(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getAddress() {
        return capnp_ts_1.Struct.getText(1, this);
      }
      setAddress(value) {
        capnp_ts_1.Struct.setText(1, value, this);
      }
      adoptHttp(value) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      disownHttp() {
        return capnp_ts_1.Struct.disown(this.getHttp());
      }
      getHttp() {
        capnp_ts_1.Struct.testWhich("http", capnp_ts_1.Struct.getUint16(0, this), 0, this);
        return capnp_ts_1.Struct.getStruct(2, HttpOptions, this);
      }
      hasHttp() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(2, this));
      }
      initHttp() {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        return capnp_ts_1.Struct.initStructAt(2, HttpOptions, this);
      }
      isHttp() {
        return capnp_ts_1.Struct.getUint16(0, this) === 0;
      }
      setHttp(value) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      getHttps() {
        capnp_ts_1.Struct.testWhich("https", capnp_ts_1.Struct.getUint16(0, this), 1, this);
        return capnp_ts_1.Struct.getAs(Socket_Https, this);
      }
      initHttps() {
        capnp_ts_1.Struct.setUint16(0, 1, this);
        return capnp_ts_1.Struct.getAs(Socket_Https, this);
      }
      isHttps() {
        return capnp_ts_1.Struct.getUint16(0, this) === 1;
      }
      setHttps() {
        capnp_ts_1.Struct.setUint16(0, 1, this);
      }
      adoptService(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(4, this));
      }
      disownService() {
        return capnp_ts_1.Struct.disown(this.getService());
      }
      getService() {
        return capnp_ts_1.Struct.getStruct(4, ServiceDesignator2, this);
      }
      hasService() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(4, this));
      }
      initService() {
        return capnp_ts_1.Struct.initStructAt(4, ServiceDesignator2, this);
      }
      setService(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(4, this));
      }
      toString() {
        return "Socket_" + super.toString();
      }
      which() {
        return capnp_ts_1.Struct.getUint16(0, this);
      }
    };
    exports.Socket = Socket2;
    Socket2.HTTP = Socket_Which.HTTP;
    Socket2.HTTPS = Socket_Which.HTTPS;
    Socket2._capnp = { displayName: "Socket", id: "9a0eba45530ee79f", size: new capnp_ts_1.ObjectSize(8, 5) };
    var Service_Which;
    (function(Service_Which2) {
      Service_Which2[Service_Which2["UNSPECIFIED"] = 0] = "UNSPECIFIED";
      Service_Which2[Service_Which2["WORKER"] = 1] = "WORKER";
      Service_Which2[Service_Which2["NETWORK"] = 2] = "NETWORK";
      Service_Which2[Service_Which2["EXTERNAL"] = 3] = "EXTERNAL";
      Service_Which2[Service_Which2["DISK"] = 4] = "DISK";
    })(Service_Which = exports.Service_Which || (exports.Service_Which = {}));
    var Service3 = class extends capnp_ts_1.Struct {
      getName() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setName(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      isUnspecified() {
        return capnp_ts_1.Struct.getUint16(0, this) === 0;
      }
      setUnspecified() {
        capnp_ts_1.Struct.setUint16(0, 0, this);
      }
      adoptWorker(value) {
        capnp_ts_1.Struct.setUint16(0, 1, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownWorker() {
        return capnp_ts_1.Struct.disown(this.getWorker());
      }
      getWorker() {
        capnp_ts_1.Struct.testWhich("worker", capnp_ts_1.Struct.getUint16(0, this), 1, this);
        return capnp_ts_1.Struct.getStruct(1, Worker2, this);
      }
      hasWorker() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initWorker() {
        capnp_ts_1.Struct.setUint16(0, 1, this);
        return capnp_ts_1.Struct.initStructAt(1, Worker2, this);
      }
      isWorker() {
        return capnp_ts_1.Struct.getUint16(0, this) === 1;
      }
      setWorker(value) {
        capnp_ts_1.Struct.setUint16(0, 1, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptNetwork(value) {
        capnp_ts_1.Struct.setUint16(0, 2, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownNetwork() {
        return capnp_ts_1.Struct.disown(this.getNetwork());
      }
      getNetwork() {
        capnp_ts_1.Struct.testWhich("network", capnp_ts_1.Struct.getUint16(0, this), 2, this);
        return capnp_ts_1.Struct.getStruct(1, Network, this);
      }
      hasNetwork() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initNetwork() {
        capnp_ts_1.Struct.setUint16(0, 2, this);
        return capnp_ts_1.Struct.initStructAt(1, Network, this);
      }
      isNetwork() {
        return capnp_ts_1.Struct.getUint16(0, this) === 2;
      }
      setNetwork(value) {
        capnp_ts_1.Struct.setUint16(0, 2, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptExternal(value) {
        capnp_ts_1.Struct.setUint16(0, 3, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownExternal() {
        return capnp_ts_1.Struct.disown(this.getExternal());
      }
      getExternal() {
        capnp_ts_1.Struct.testWhich("external", capnp_ts_1.Struct.getUint16(0, this), 3, this);
        return capnp_ts_1.Struct.getStruct(1, ExternalServer2, this);
      }
      hasExternal() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initExternal() {
        capnp_ts_1.Struct.setUint16(0, 3, this);
        return capnp_ts_1.Struct.initStructAt(1, ExternalServer2, this);
      }
      isExternal() {
        return capnp_ts_1.Struct.getUint16(0, this) === 3;
      }
      setExternal(value) {
        capnp_ts_1.Struct.setUint16(0, 3, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptDisk(value) {
        capnp_ts_1.Struct.setUint16(0, 4, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownDisk() {
        return capnp_ts_1.Struct.disown(this.getDisk());
      }
      getDisk() {
        capnp_ts_1.Struct.testWhich("disk", capnp_ts_1.Struct.getUint16(0, this), 4, this);
        return capnp_ts_1.Struct.getStruct(1, DiskDirectory, this);
      }
      hasDisk() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initDisk() {
        capnp_ts_1.Struct.setUint16(0, 4, this);
        return capnp_ts_1.Struct.initStructAt(1, DiskDirectory, this);
      }
      isDisk() {
        return capnp_ts_1.Struct.getUint16(0, this) === 4;
      }
      setDisk(value) {
        capnp_ts_1.Struct.setUint16(0, 4, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      toString() {
        return "Service_" + super.toString();
      }
      which() {
        return capnp_ts_1.Struct.getUint16(0, this);
      }
    };
    exports.Service = Service3;
    Service3.UNSPECIFIED = Service_Which.UNSPECIFIED;
    Service3.WORKER = Service_Which.WORKER;
    Service3.NETWORK = Service_Which.NETWORK;
    Service3.EXTERNAL = Service_Which.EXTERNAL;
    Service3.DISK = Service_Which.DISK;
    Service3._capnp = { displayName: "Service", id: "e5c88e8bb7bcb6b9", size: new capnp_ts_1.ObjectSize(8, 2) };
    var ServiceDesignator2 = class extends capnp_ts_1.Struct {
      getName() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setName(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getEntrypoint() {
        return capnp_ts_1.Struct.getText(1, this);
      }
      setEntrypoint(value) {
        capnp_ts_1.Struct.setText(1, value, this);
      }
      toString() {
        return "ServiceDesignator_" + super.toString();
      }
    };
    exports.ServiceDesignator = ServiceDesignator2;
    ServiceDesignator2._capnp = { displayName: "ServiceDesignator", id: "ae8ec91cee724450", size: new capnp_ts_1.ObjectSize(0, 2) };
    var Worker_Module_Which;
    (function(Worker_Module_Which2) {
      Worker_Module_Which2[Worker_Module_Which2["ES_MODULE"] = 0] = "ES_MODULE";
      Worker_Module_Which2[Worker_Module_Which2["COMMON_JS_MODULE"] = 1] = "COMMON_JS_MODULE";
      Worker_Module_Which2[Worker_Module_Which2["TEXT"] = 2] = "TEXT";
      Worker_Module_Which2[Worker_Module_Which2["DATA"] = 3] = "DATA";
      Worker_Module_Which2[Worker_Module_Which2["WASM"] = 4] = "WASM";
      Worker_Module_Which2[Worker_Module_Which2["JSON"] = 5] = "JSON";
      Worker_Module_Which2[Worker_Module_Which2["NODE_JS_COMPAT_MODULE"] = 6] = "NODE_JS_COMPAT_MODULE";
    })(Worker_Module_Which = exports.Worker_Module_Which || (exports.Worker_Module_Which = {}));
    var Worker_Module3 = class extends capnp_ts_1.Struct {
      getName() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setName(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getEsModule() {
        capnp_ts_1.Struct.testWhich("esModule", capnp_ts_1.Struct.getUint16(0, this), 0, this);
        return capnp_ts_1.Struct.getText(1, this);
      }
      isEsModule() {
        return capnp_ts_1.Struct.getUint16(0, this) === 0;
      }
      setEsModule(value) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        capnp_ts_1.Struct.setText(1, value, this);
      }
      getCommonJsModule() {
        capnp_ts_1.Struct.testWhich("commonJsModule", capnp_ts_1.Struct.getUint16(0, this), 1, this);
        return capnp_ts_1.Struct.getText(1, this);
      }
      isCommonJsModule() {
        return capnp_ts_1.Struct.getUint16(0, this) === 1;
      }
      setCommonJsModule(value) {
        capnp_ts_1.Struct.setUint16(0, 1, this);
        capnp_ts_1.Struct.setText(1, value, this);
      }
      getText() {
        capnp_ts_1.Struct.testWhich("text", capnp_ts_1.Struct.getUint16(0, this), 2, this);
        return capnp_ts_1.Struct.getText(1, this);
      }
      isText() {
        return capnp_ts_1.Struct.getUint16(0, this) === 2;
      }
      setText(value) {
        capnp_ts_1.Struct.setUint16(0, 2, this);
        capnp_ts_1.Struct.setText(1, value, this);
      }
      adoptData(value) {
        capnp_ts_1.Struct.setUint16(0, 3, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownData() {
        return capnp_ts_1.Struct.disown(this.getData());
      }
      getData() {
        capnp_ts_1.Struct.testWhich("data", capnp_ts_1.Struct.getUint16(0, this), 3, this);
        return capnp_ts_1.Struct.getData(1, this);
      }
      hasData() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initData(length) {
        capnp_ts_1.Struct.setUint16(0, 3, this);
        return capnp_ts_1.Struct.initData(1, length, this);
      }
      isData() {
        return capnp_ts_1.Struct.getUint16(0, this) === 3;
      }
      setData(value) {
        capnp_ts_1.Struct.setUint16(0, 3, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptWasm(value) {
        capnp_ts_1.Struct.setUint16(0, 4, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownWasm() {
        return capnp_ts_1.Struct.disown(this.getWasm());
      }
      getWasm() {
        capnp_ts_1.Struct.testWhich("wasm", capnp_ts_1.Struct.getUint16(0, this), 4, this);
        return capnp_ts_1.Struct.getData(1, this);
      }
      hasWasm() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initWasm(length) {
        capnp_ts_1.Struct.setUint16(0, 4, this);
        return capnp_ts_1.Struct.initData(1, length, this);
      }
      isWasm() {
        return capnp_ts_1.Struct.getUint16(0, this) === 4;
      }
      setWasm(value) {
        capnp_ts_1.Struct.setUint16(0, 4, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      getJson() {
        capnp_ts_1.Struct.testWhich("json", capnp_ts_1.Struct.getUint16(0, this), 5, this);
        return capnp_ts_1.Struct.getText(1, this);
      }
      isJson() {
        return capnp_ts_1.Struct.getUint16(0, this) === 5;
      }
      setJson(value) {
        capnp_ts_1.Struct.setUint16(0, 5, this);
        capnp_ts_1.Struct.setText(1, value, this);
      }
      getNodeJsCompatModule() {
        capnp_ts_1.Struct.testWhich("nodeJsCompatModule", capnp_ts_1.Struct.getUint16(0, this), 6, this);
        return capnp_ts_1.Struct.getText(1, this);
      }
      isNodeJsCompatModule() {
        return capnp_ts_1.Struct.getUint16(0, this) === 6;
      }
      setNodeJsCompatModule(value) {
        capnp_ts_1.Struct.setUint16(0, 6, this);
        capnp_ts_1.Struct.setText(1, value, this);
      }
      toString() {
        return "Worker_Module_" + super.toString();
      }
      which() {
        return capnp_ts_1.Struct.getUint16(0, this);
      }
    };
    exports.Worker_Module = Worker_Module3;
    Worker_Module3.ES_MODULE = Worker_Module_Which.ES_MODULE;
    Worker_Module3.COMMON_JS_MODULE = Worker_Module_Which.COMMON_JS_MODULE;
    Worker_Module3.TEXT = Worker_Module_Which.TEXT;
    Worker_Module3.DATA = Worker_Module_Which.DATA;
    Worker_Module3.WASM = Worker_Module_Which.WASM;
    Worker_Module3.JSON = Worker_Module_Which.JSON;
    Worker_Module3.NODE_JS_COMPAT_MODULE = Worker_Module_Which.NODE_JS_COMPAT_MODULE;
    Worker_Module3._capnp = { displayName: "Module", id: "d9d87a63770a12f3", size: new capnp_ts_1.ObjectSize(8, 2) };
    var Worker_Binding_Type_Which;
    (function(Worker_Binding_Type_Which2) {
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["UNSPECIFIED"] = 0] = "UNSPECIFIED";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["TEXT"] = 1] = "TEXT";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["DATA"] = 2] = "DATA";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["JSON"] = 3] = "JSON";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["WASM"] = 4] = "WASM";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["CRYPTO_KEY"] = 5] = "CRYPTO_KEY";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["SERVICE"] = 6] = "SERVICE";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["DURABLE_OBJECT_NAMESPACE"] = 7] = "DURABLE_OBJECT_NAMESPACE";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["KV_NAMESPACE"] = 8] = "KV_NAMESPACE";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["R2BUCKET"] = 9] = "R2BUCKET";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["R2ADMIN"] = 10] = "R2ADMIN";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["QUEUE"] = 11] = "QUEUE";
      Worker_Binding_Type_Which2[Worker_Binding_Type_Which2["ANALYTICS_ENGINE"] = 12] = "ANALYTICS_ENGINE";
    })(Worker_Binding_Type_Which = exports.Worker_Binding_Type_Which || (exports.Worker_Binding_Type_Which = {}));
    var Worker_Binding_Type = class extends capnp_ts_1.Struct {
      isUnspecified() {
        return capnp_ts_1.Struct.getUint16(0, this) === 0;
      }
      setUnspecified() {
        capnp_ts_1.Struct.setUint16(0, 0, this);
      }
      isText() {
        return capnp_ts_1.Struct.getUint16(0, this) === 1;
      }
      setText() {
        capnp_ts_1.Struct.setUint16(0, 1, this);
      }
      isData() {
        return capnp_ts_1.Struct.getUint16(0, this) === 2;
      }
      setData() {
        capnp_ts_1.Struct.setUint16(0, 2, this);
      }
      isJson() {
        return capnp_ts_1.Struct.getUint16(0, this) === 3;
      }
      setJson() {
        capnp_ts_1.Struct.setUint16(0, 3, this);
      }
      isWasm() {
        return capnp_ts_1.Struct.getUint16(0, this) === 4;
      }
      setWasm() {
        capnp_ts_1.Struct.setUint16(0, 4, this);
      }
      adoptCryptoKey(value) {
        capnp_ts_1.Struct.setUint16(0, 5, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      disownCryptoKey() {
        return capnp_ts_1.Struct.disown(this.getCryptoKey());
      }
      getCryptoKey() {
        capnp_ts_1.Struct.testWhich("cryptoKey", capnp_ts_1.Struct.getUint16(0, this), 5, this);
        return capnp_ts_1.Struct.getList(0, capnp.Uint16List, this);
      }
      hasCryptoKey() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(0, this));
      }
      initCryptoKey(length) {
        capnp_ts_1.Struct.setUint16(0, 5, this);
        return capnp_ts_1.Struct.initList(0, capnp.Uint16List, length, this);
      }
      isCryptoKey() {
        return capnp_ts_1.Struct.getUint16(0, this) === 5;
      }
      setCryptoKey(value) {
        capnp_ts_1.Struct.setUint16(0, 5, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      isService() {
        return capnp_ts_1.Struct.getUint16(0, this) === 6;
      }
      setService() {
        capnp_ts_1.Struct.setUint16(0, 6, this);
      }
      isDurableObjectNamespace() {
        return capnp_ts_1.Struct.getUint16(0, this) === 7;
      }
      setDurableObjectNamespace() {
        capnp_ts_1.Struct.setUint16(0, 7, this);
      }
      isKvNamespace() {
        return capnp_ts_1.Struct.getUint16(0, this) === 8;
      }
      setKvNamespace() {
        capnp_ts_1.Struct.setUint16(0, 8, this);
      }
      isR2Bucket() {
        return capnp_ts_1.Struct.getUint16(0, this) === 9;
      }
      setR2Bucket() {
        capnp_ts_1.Struct.setUint16(0, 9, this);
      }
      isR2Admin() {
        return capnp_ts_1.Struct.getUint16(0, this) === 10;
      }
      setR2Admin() {
        capnp_ts_1.Struct.setUint16(0, 10, this);
      }
      isQueue() {
        return capnp_ts_1.Struct.getUint16(0, this) === 11;
      }
      setQueue() {
        capnp_ts_1.Struct.setUint16(0, 11, this);
      }
      isAnalyticsEngine() {
        return capnp_ts_1.Struct.getUint16(0, this) === 12;
      }
      setAnalyticsEngine() {
        capnp_ts_1.Struct.setUint16(0, 12, this);
      }
      toString() {
        return "Worker_Binding_Type_" + super.toString();
      }
      which() {
        return capnp_ts_1.Struct.getUint16(0, this);
      }
    };
    exports.Worker_Binding_Type = Worker_Binding_Type;
    Worker_Binding_Type.UNSPECIFIED = Worker_Binding_Type_Which.UNSPECIFIED;
    Worker_Binding_Type.TEXT = Worker_Binding_Type_Which.TEXT;
    Worker_Binding_Type.DATA = Worker_Binding_Type_Which.DATA;
    Worker_Binding_Type.JSON = Worker_Binding_Type_Which.JSON;
    Worker_Binding_Type.WASM = Worker_Binding_Type_Which.WASM;
    Worker_Binding_Type.CRYPTO_KEY = Worker_Binding_Type_Which.CRYPTO_KEY;
    Worker_Binding_Type.SERVICE = Worker_Binding_Type_Which.SERVICE;
    Worker_Binding_Type.DURABLE_OBJECT_NAMESPACE = Worker_Binding_Type_Which.DURABLE_OBJECT_NAMESPACE;
    Worker_Binding_Type.KV_NAMESPACE = Worker_Binding_Type_Which.KV_NAMESPACE;
    Worker_Binding_Type.R2BUCKET = Worker_Binding_Type_Which.R2BUCKET;
    Worker_Binding_Type.R2ADMIN = Worker_Binding_Type_Which.R2ADMIN;
    Worker_Binding_Type.QUEUE = Worker_Binding_Type_Which.QUEUE;
    Worker_Binding_Type.ANALYTICS_ENGINE = Worker_Binding_Type_Which.ANALYTICS_ENGINE;
    Worker_Binding_Type._capnp = { displayName: "Type", id: "8906a1296519bf8a", size: new capnp_ts_1.ObjectSize(8, 1) };
    var Worker_Binding_DurableObjectNamespaceDesignator = class extends capnp_ts_1.Struct {
      getClassName() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setClassName(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getServiceName() {
        return capnp_ts_1.Struct.getText(1, this);
      }
      setServiceName(value) {
        capnp_ts_1.Struct.setText(1, value, this);
      }
      toString() {
        return "Worker_Binding_DurableObjectNamespaceDesignator_" + super.toString();
      }
    };
    exports.Worker_Binding_DurableObjectNamespaceDesignator = Worker_Binding_DurableObjectNamespaceDesignator;
    Worker_Binding_DurableObjectNamespaceDesignator._capnp = { displayName: "DurableObjectNamespaceDesignator", id: "804f144ff477aac7", size: new capnp_ts_1.ObjectSize(0, 2) };
    var Worker_Binding_CryptoKey_Usage2;
    (function(Worker_Binding_CryptoKey_Usage3) {
      Worker_Binding_CryptoKey_Usage3[Worker_Binding_CryptoKey_Usage3["ENCRYPT"] = 0] = "ENCRYPT";
      Worker_Binding_CryptoKey_Usage3[Worker_Binding_CryptoKey_Usage3["DECRYPT"] = 1] = "DECRYPT";
      Worker_Binding_CryptoKey_Usage3[Worker_Binding_CryptoKey_Usage3["SIGN"] = 2] = "SIGN";
      Worker_Binding_CryptoKey_Usage3[Worker_Binding_CryptoKey_Usage3["VERIFY"] = 3] = "VERIFY";
      Worker_Binding_CryptoKey_Usage3[Worker_Binding_CryptoKey_Usage3["DERIVE_KEY"] = 4] = "DERIVE_KEY";
      Worker_Binding_CryptoKey_Usage3[Worker_Binding_CryptoKey_Usage3["DERIVE_BITS"] = 5] = "DERIVE_BITS";
      Worker_Binding_CryptoKey_Usage3[Worker_Binding_CryptoKey_Usage3["WRAP_KEY"] = 6] = "WRAP_KEY";
      Worker_Binding_CryptoKey_Usage3[Worker_Binding_CryptoKey_Usage3["UNWRAP_KEY"] = 7] = "UNWRAP_KEY";
    })(Worker_Binding_CryptoKey_Usage2 = exports.Worker_Binding_CryptoKey_Usage || (exports.Worker_Binding_CryptoKey_Usage = {}));
    var Worker_Binding_CryptoKey_Algorithm_Which;
    (function(Worker_Binding_CryptoKey_Algorithm_Which2) {
      Worker_Binding_CryptoKey_Algorithm_Which2[Worker_Binding_CryptoKey_Algorithm_Which2["NAME"] = 0] = "NAME";
      Worker_Binding_CryptoKey_Algorithm_Which2[Worker_Binding_CryptoKey_Algorithm_Which2["JSON"] = 1] = "JSON";
    })(Worker_Binding_CryptoKey_Algorithm_Which = exports.Worker_Binding_CryptoKey_Algorithm_Which || (exports.Worker_Binding_CryptoKey_Algorithm_Which = {}));
    var Worker_Binding_CryptoKey_Algorithm = class extends capnp_ts_1.Struct {
      getName() {
        capnp_ts_1.Struct.testWhich("name", capnp_ts_1.Struct.getUint16(2, this), 0, this);
        return capnp_ts_1.Struct.getText(1, this);
      }
      isName() {
        return capnp_ts_1.Struct.getUint16(2, this) === 0;
      }
      setName(value) {
        capnp_ts_1.Struct.setUint16(2, 0, this);
        capnp_ts_1.Struct.setText(1, value, this);
      }
      getJson() {
        capnp_ts_1.Struct.testWhich("json", capnp_ts_1.Struct.getUint16(2, this), 1, this);
        return capnp_ts_1.Struct.getText(1, this);
      }
      isJson() {
        return capnp_ts_1.Struct.getUint16(2, this) === 1;
      }
      setJson(value) {
        capnp_ts_1.Struct.setUint16(2, 1, this);
        capnp_ts_1.Struct.setText(1, value, this);
      }
      toString() {
        return "Worker_Binding_CryptoKey_Algorithm_" + super.toString();
      }
      which() {
        return capnp_ts_1.Struct.getUint16(2, this);
      }
    };
    exports.Worker_Binding_CryptoKey_Algorithm = Worker_Binding_CryptoKey_Algorithm;
    Worker_Binding_CryptoKey_Algorithm.NAME = Worker_Binding_CryptoKey_Algorithm_Which.NAME;
    Worker_Binding_CryptoKey_Algorithm.JSON = Worker_Binding_CryptoKey_Algorithm_Which.JSON;
    Worker_Binding_CryptoKey_Algorithm._capnp = { displayName: "algorithm", id: "a1a040c5e00d7021", size: new capnp_ts_1.ObjectSize(8, 3) };
    var Worker_Binding_CryptoKey_Which;
    (function(Worker_Binding_CryptoKey_Which2) {
      Worker_Binding_CryptoKey_Which2[Worker_Binding_CryptoKey_Which2["RAW"] = 0] = "RAW";
      Worker_Binding_CryptoKey_Which2[Worker_Binding_CryptoKey_Which2["HEX"] = 1] = "HEX";
      Worker_Binding_CryptoKey_Which2[Worker_Binding_CryptoKey_Which2["BASE64"] = 2] = "BASE64";
      Worker_Binding_CryptoKey_Which2[Worker_Binding_CryptoKey_Which2["PKCS8"] = 3] = "PKCS8";
      Worker_Binding_CryptoKey_Which2[Worker_Binding_CryptoKey_Which2["SPKI"] = 4] = "SPKI";
      Worker_Binding_CryptoKey_Which2[Worker_Binding_CryptoKey_Which2["JWK"] = 5] = "JWK";
    })(Worker_Binding_CryptoKey_Which = exports.Worker_Binding_CryptoKey_Which || (exports.Worker_Binding_CryptoKey_Which = {}));
    var Worker_Binding_CryptoKey = class extends capnp_ts_1.Struct {
      adoptRaw(value) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      disownRaw() {
        return capnp_ts_1.Struct.disown(this.getRaw());
      }
      getRaw() {
        capnp_ts_1.Struct.testWhich("raw", capnp_ts_1.Struct.getUint16(0, this), 0, this);
        return capnp_ts_1.Struct.getData(0, this);
      }
      hasRaw() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(0, this));
      }
      initRaw(length) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        return capnp_ts_1.Struct.initData(0, length, this);
      }
      isRaw() {
        return capnp_ts_1.Struct.getUint16(0, this) === 0;
      }
      setRaw(value) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      getHex() {
        capnp_ts_1.Struct.testWhich("hex", capnp_ts_1.Struct.getUint16(0, this), 1, this);
        return capnp_ts_1.Struct.getText(0, this);
      }
      isHex() {
        return capnp_ts_1.Struct.getUint16(0, this) === 1;
      }
      setHex(value) {
        capnp_ts_1.Struct.setUint16(0, 1, this);
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getBase64() {
        capnp_ts_1.Struct.testWhich("base64", capnp_ts_1.Struct.getUint16(0, this), 2, this);
        return capnp_ts_1.Struct.getText(0, this);
      }
      isBase64() {
        return capnp_ts_1.Struct.getUint16(0, this) === 2;
      }
      setBase64(value) {
        capnp_ts_1.Struct.setUint16(0, 2, this);
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getPkcs8() {
        capnp_ts_1.Struct.testWhich("pkcs8", capnp_ts_1.Struct.getUint16(0, this), 3, this);
        return capnp_ts_1.Struct.getText(0, this);
      }
      isPkcs8() {
        return capnp_ts_1.Struct.getUint16(0, this) === 3;
      }
      setPkcs8(value) {
        capnp_ts_1.Struct.setUint16(0, 3, this);
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getSpki() {
        capnp_ts_1.Struct.testWhich("spki", capnp_ts_1.Struct.getUint16(0, this), 4, this);
        return capnp_ts_1.Struct.getText(0, this);
      }
      isSpki() {
        return capnp_ts_1.Struct.getUint16(0, this) === 4;
      }
      setSpki(value) {
        capnp_ts_1.Struct.setUint16(0, 4, this);
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getJwk() {
        capnp_ts_1.Struct.testWhich("jwk", capnp_ts_1.Struct.getUint16(0, this), 5, this);
        return capnp_ts_1.Struct.getText(0, this);
      }
      isJwk() {
        return capnp_ts_1.Struct.getUint16(0, this) === 5;
      }
      setJwk(value) {
        capnp_ts_1.Struct.setUint16(0, 5, this);
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getAlgorithm() {
        return capnp_ts_1.Struct.getAs(Worker_Binding_CryptoKey_Algorithm, this);
      }
      initAlgorithm() {
        return capnp_ts_1.Struct.getAs(Worker_Binding_CryptoKey_Algorithm, this);
      }
      getExtractable() {
        return capnp_ts_1.Struct.getBit(32, this, Worker_Binding_CryptoKey._capnp.defaultExtractable);
      }
      setExtractable(value) {
        capnp_ts_1.Struct.setBit(32, value, this);
      }
      adoptUsages(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      disownUsages() {
        return capnp_ts_1.Struct.disown(this.getUsages());
      }
      getUsages() {
        return capnp_ts_1.Struct.getList(2, capnp.Uint16List, this);
      }
      hasUsages() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(2, this));
      }
      initUsages(length) {
        return capnp_ts_1.Struct.initList(2, capnp.Uint16List, length, this);
      }
      setUsages(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      toString() {
        return "Worker_Binding_CryptoKey_" + super.toString();
      }
      which() {
        return capnp_ts_1.Struct.getUint16(0, this);
      }
    };
    exports.Worker_Binding_CryptoKey = Worker_Binding_CryptoKey;
    Worker_Binding_CryptoKey.RAW = Worker_Binding_CryptoKey_Which.RAW;
    Worker_Binding_CryptoKey.HEX = Worker_Binding_CryptoKey_Which.HEX;
    Worker_Binding_CryptoKey.BASE64 = Worker_Binding_CryptoKey_Which.BASE64;
    Worker_Binding_CryptoKey.PKCS8 = Worker_Binding_CryptoKey_Which.PKCS8;
    Worker_Binding_CryptoKey.SPKI = Worker_Binding_CryptoKey_Which.SPKI;
    Worker_Binding_CryptoKey.JWK = Worker_Binding_CryptoKey_Which.JWK;
    Worker_Binding_CryptoKey.Usage = Worker_Binding_CryptoKey_Usage2;
    Worker_Binding_CryptoKey._capnp = { displayName: "CryptoKey", id: "b5e1bff0e57d6eb0", size: new capnp_ts_1.ObjectSize(8, 3), defaultExtractable: capnp.getBitMask(false, 0) };
    var Worker_Binding_WrappedBinding = class extends capnp_ts_1.Struct {
      getModuleName() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setModuleName(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getEntrypoint() {
        return capnp_ts_1.Struct.getText(1, this, Worker_Binding_WrappedBinding._capnp.defaultEntrypoint);
      }
      setEntrypoint(value) {
        capnp_ts_1.Struct.setText(1, value, this);
      }
      adoptInnerBindings(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      disownInnerBindings() {
        return capnp_ts_1.Struct.disown(this.getInnerBindings());
      }
      getInnerBindings() {
        return capnp_ts_1.Struct.getList(2, Worker_Binding_WrappedBinding._InnerBindings, this);
      }
      hasInnerBindings() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(2, this));
      }
      initInnerBindings(length) {
        return capnp_ts_1.Struct.initList(2, Worker_Binding_WrappedBinding._InnerBindings, length, this);
      }
      setInnerBindings(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      toString() {
        return "Worker_Binding_WrappedBinding_" + super.toString();
      }
    };
    exports.Worker_Binding_WrappedBinding = Worker_Binding_WrappedBinding;
    Worker_Binding_WrappedBinding._capnp = { displayName: "WrappedBinding", id: "e6f066b75f0ea113", size: new capnp_ts_1.ObjectSize(0, 3), defaultEntrypoint: "default" };
    var Worker_Binding_Parameter = class extends capnp_ts_1.Struct {
      adoptType(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownType() {
        return capnp_ts_1.Struct.disown(this.getType());
      }
      getType() {
        return capnp_ts_1.Struct.getStruct(1, Worker_Binding_Type, this);
      }
      hasType() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initType() {
        return capnp_ts_1.Struct.initStructAt(1, Worker_Binding_Type, this);
      }
      setType(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      getOptional() {
        return capnp_ts_1.Struct.getBit(16, this);
      }
      setOptional(value) {
        capnp_ts_1.Struct.setBit(16, value, this);
      }
      toString() {
        return "Worker_Binding_Parameter_" + super.toString();
      }
    };
    exports.Worker_Binding_Parameter = Worker_Binding_Parameter;
    Worker_Binding_Parameter._capnp = { displayName: "parameter", id: "dc57e1258d26d152", size: new capnp_ts_1.ObjectSize(8, 2) };
    var Worker_Binding_Which;
    (function(Worker_Binding_Which2) {
      Worker_Binding_Which2[Worker_Binding_Which2["UNSPECIFIED"] = 0] = "UNSPECIFIED";
      Worker_Binding_Which2[Worker_Binding_Which2["PARAMETER"] = 1] = "PARAMETER";
      Worker_Binding_Which2[Worker_Binding_Which2["TEXT"] = 2] = "TEXT";
      Worker_Binding_Which2[Worker_Binding_Which2["DATA"] = 3] = "DATA";
      Worker_Binding_Which2[Worker_Binding_Which2["JSON"] = 4] = "JSON";
      Worker_Binding_Which2[Worker_Binding_Which2["WASM_MODULE"] = 5] = "WASM_MODULE";
      Worker_Binding_Which2[Worker_Binding_Which2["CRYPTO_KEY"] = 6] = "CRYPTO_KEY";
      Worker_Binding_Which2[Worker_Binding_Which2["SERVICE"] = 7] = "SERVICE";
      Worker_Binding_Which2[Worker_Binding_Which2["DURABLE_OBJECT_NAMESPACE"] = 8] = "DURABLE_OBJECT_NAMESPACE";
      Worker_Binding_Which2[Worker_Binding_Which2["KV_NAMESPACE"] = 9] = "KV_NAMESPACE";
      Worker_Binding_Which2[Worker_Binding_Which2["R2BUCKET"] = 10] = "R2BUCKET";
      Worker_Binding_Which2[Worker_Binding_Which2["R2ADMIN"] = 11] = "R2ADMIN";
      Worker_Binding_Which2[Worker_Binding_Which2["WRAPPED"] = 12] = "WRAPPED";
      Worker_Binding_Which2[Worker_Binding_Which2["QUEUE"] = 13] = "QUEUE";
      Worker_Binding_Which2[Worker_Binding_Which2["FROM_ENVIRONMENT"] = 14] = "FROM_ENVIRONMENT";
      Worker_Binding_Which2[Worker_Binding_Which2["ANALYTICS_ENGINE"] = 15] = "ANALYTICS_ENGINE";
    })(Worker_Binding_Which = exports.Worker_Binding_Which || (exports.Worker_Binding_Which = {}));
    var Worker_Binding3 = class extends capnp_ts_1.Struct {
      getName() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setName(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      isUnspecified() {
        return capnp_ts_1.Struct.getUint16(0, this) === 0;
      }
      setUnspecified() {
        capnp_ts_1.Struct.setUint16(0, 0, this);
      }
      getParameter() {
        capnp_ts_1.Struct.testWhich("parameter", capnp_ts_1.Struct.getUint16(0, this), 1, this);
        return capnp_ts_1.Struct.getAs(Worker_Binding_Parameter, this);
      }
      initParameter() {
        capnp_ts_1.Struct.setUint16(0, 1, this);
        return capnp_ts_1.Struct.getAs(Worker_Binding_Parameter, this);
      }
      isParameter() {
        return capnp_ts_1.Struct.getUint16(0, this) === 1;
      }
      setParameter() {
        capnp_ts_1.Struct.setUint16(0, 1, this);
      }
      getText() {
        capnp_ts_1.Struct.testWhich("text", capnp_ts_1.Struct.getUint16(0, this), 2, this);
        return capnp_ts_1.Struct.getText(1, this);
      }
      isText() {
        return capnp_ts_1.Struct.getUint16(0, this) === 2;
      }
      setText(value) {
        capnp_ts_1.Struct.setUint16(0, 2, this);
        capnp_ts_1.Struct.setText(1, value, this);
      }
      adoptData(value) {
        capnp_ts_1.Struct.setUint16(0, 3, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownData() {
        return capnp_ts_1.Struct.disown(this.getData());
      }
      getData() {
        capnp_ts_1.Struct.testWhich("data", capnp_ts_1.Struct.getUint16(0, this), 3, this);
        return capnp_ts_1.Struct.getData(1, this);
      }
      hasData() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initData(length) {
        capnp_ts_1.Struct.setUint16(0, 3, this);
        return capnp_ts_1.Struct.initData(1, length, this);
      }
      isData() {
        return capnp_ts_1.Struct.getUint16(0, this) === 3;
      }
      setData(value) {
        capnp_ts_1.Struct.setUint16(0, 3, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      getJson() {
        capnp_ts_1.Struct.testWhich("json", capnp_ts_1.Struct.getUint16(0, this), 4, this);
        return capnp_ts_1.Struct.getText(1, this);
      }
      isJson() {
        return capnp_ts_1.Struct.getUint16(0, this) === 4;
      }
      setJson(value) {
        capnp_ts_1.Struct.setUint16(0, 4, this);
        capnp_ts_1.Struct.setText(1, value, this);
      }
      adoptWasmModule(value) {
        capnp_ts_1.Struct.setUint16(0, 5, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownWasmModule() {
        return capnp_ts_1.Struct.disown(this.getWasmModule());
      }
      getWasmModule() {
        capnp_ts_1.Struct.testWhich("wasmModule", capnp_ts_1.Struct.getUint16(0, this), 5, this);
        return capnp_ts_1.Struct.getData(1, this);
      }
      hasWasmModule() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initWasmModule(length) {
        capnp_ts_1.Struct.setUint16(0, 5, this);
        return capnp_ts_1.Struct.initData(1, length, this);
      }
      isWasmModule() {
        return capnp_ts_1.Struct.getUint16(0, this) === 5;
      }
      setWasmModule(value) {
        capnp_ts_1.Struct.setUint16(0, 5, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptCryptoKey(value) {
        capnp_ts_1.Struct.setUint16(0, 6, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownCryptoKey() {
        return capnp_ts_1.Struct.disown(this.getCryptoKey());
      }
      getCryptoKey() {
        capnp_ts_1.Struct.testWhich("cryptoKey", capnp_ts_1.Struct.getUint16(0, this), 6, this);
        return capnp_ts_1.Struct.getStruct(1, Worker_Binding_CryptoKey, this);
      }
      hasCryptoKey() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initCryptoKey() {
        capnp_ts_1.Struct.setUint16(0, 6, this);
        return capnp_ts_1.Struct.initStructAt(1, Worker_Binding_CryptoKey, this);
      }
      isCryptoKey() {
        return capnp_ts_1.Struct.getUint16(0, this) === 6;
      }
      setCryptoKey(value) {
        capnp_ts_1.Struct.setUint16(0, 6, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptService(value) {
        capnp_ts_1.Struct.setUint16(0, 7, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownService() {
        return capnp_ts_1.Struct.disown(this.getService());
      }
      getService() {
        capnp_ts_1.Struct.testWhich("service", capnp_ts_1.Struct.getUint16(0, this), 7, this);
        return capnp_ts_1.Struct.getStruct(1, ServiceDesignator2, this);
      }
      hasService() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initService() {
        capnp_ts_1.Struct.setUint16(0, 7, this);
        return capnp_ts_1.Struct.initStructAt(1, ServiceDesignator2, this);
      }
      isService() {
        return capnp_ts_1.Struct.getUint16(0, this) === 7;
      }
      setService(value) {
        capnp_ts_1.Struct.setUint16(0, 7, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptDurableObjectNamespace(value) {
        capnp_ts_1.Struct.setUint16(0, 8, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownDurableObjectNamespace() {
        return capnp_ts_1.Struct.disown(this.getDurableObjectNamespace());
      }
      getDurableObjectNamespace() {
        capnp_ts_1.Struct.testWhich("durableObjectNamespace", capnp_ts_1.Struct.getUint16(0, this), 8, this);
        return capnp_ts_1.Struct.getStruct(1, Worker_Binding_DurableObjectNamespaceDesignator, this);
      }
      hasDurableObjectNamespace() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initDurableObjectNamespace() {
        capnp_ts_1.Struct.setUint16(0, 8, this);
        return capnp_ts_1.Struct.initStructAt(1, Worker_Binding_DurableObjectNamespaceDesignator, this);
      }
      isDurableObjectNamespace() {
        return capnp_ts_1.Struct.getUint16(0, this) === 8;
      }
      setDurableObjectNamespace(value) {
        capnp_ts_1.Struct.setUint16(0, 8, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptKvNamespace(value) {
        capnp_ts_1.Struct.setUint16(0, 9, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownKvNamespace() {
        return capnp_ts_1.Struct.disown(this.getKvNamespace());
      }
      getKvNamespace() {
        capnp_ts_1.Struct.testWhich("kvNamespace", capnp_ts_1.Struct.getUint16(0, this), 9, this);
        return capnp_ts_1.Struct.getStruct(1, ServiceDesignator2, this);
      }
      hasKvNamespace() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initKvNamespace() {
        capnp_ts_1.Struct.setUint16(0, 9, this);
        return capnp_ts_1.Struct.initStructAt(1, ServiceDesignator2, this);
      }
      isKvNamespace() {
        return capnp_ts_1.Struct.getUint16(0, this) === 9;
      }
      setKvNamespace(value) {
        capnp_ts_1.Struct.setUint16(0, 9, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptR2Bucket(value) {
        capnp_ts_1.Struct.setUint16(0, 10, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownR2Bucket() {
        return capnp_ts_1.Struct.disown(this.getR2Bucket());
      }
      getR2Bucket() {
        capnp_ts_1.Struct.testWhich("r2Bucket", capnp_ts_1.Struct.getUint16(0, this), 10, this);
        return capnp_ts_1.Struct.getStruct(1, ServiceDesignator2, this);
      }
      hasR2Bucket() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initR2Bucket() {
        capnp_ts_1.Struct.setUint16(0, 10, this);
        return capnp_ts_1.Struct.initStructAt(1, ServiceDesignator2, this);
      }
      isR2Bucket() {
        return capnp_ts_1.Struct.getUint16(0, this) === 10;
      }
      setR2Bucket(value) {
        capnp_ts_1.Struct.setUint16(0, 10, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptR2Admin(value) {
        capnp_ts_1.Struct.setUint16(0, 11, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownR2Admin() {
        return capnp_ts_1.Struct.disown(this.getR2Admin());
      }
      getR2Admin() {
        capnp_ts_1.Struct.testWhich("r2Admin", capnp_ts_1.Struct.getUint16(0, this), 11, this);
        return capnp_ts_1.Struct.getStruct(1, ServiceDesignator2, this);
      }
      hasR2Admin() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initR2Admin() {
        capnp_ts_1.Struct.setUint16(0, 11, this);
        return capnp_ts_1.Struct.initStructAt(1, ServiceDesignator2, this);
      }
      isR2Admin() {
        return capnp_ts_1.Struct.getUint16(0, this) === 11;
      }
      setR2Admin(value) {
        capnp_ts_1.Struct.setUint16(0, 11, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptWrapped(value) {
        capnp_ts_1.Struct.setUint16(0, 12, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownWrapped() {
        return capnp_ts_1.Struct.disown(this.getWrapped());
      }
      getWrapped() {
        capnp_ts_1.Struct.testWhich("wrapped", capnp_ts_1.Struct.getUint16(0, this), 12, this);
        return capnp_ts_1.Struct.getStruct(1, Worker_Binding_WrappedBinding, this);
      }
      hasWrapped() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initWrapped() {
        capnp_ts_1.Struct.setUint16(0, 12, this);
        return capnp_ts_1.Struct.initStructAt(1, Worker_Binding_WrappedBinding, this);
      }
      isWrapped() {
        return capnp_ts_1.Struct.getUint16(0, this) === 12;
      }
      setWrapped(value) {
        capnp_ts_1.Struct.setUint16(0, 12, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptQueue(value) {
        capnp_ts_1.Struct.setUint16(0, 13, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownQueue() {
        return capnp_ts_1.Struct.disown(this.getQueue());
      }
      getQueue() {
        capnp_ts_1.Struct.testWhich("queue", capnp_ts_1.Struct.getUint16(0, this), 13, this);
        return capnp_ts_1.Struct.getStruct(1, ServiceDesignator2, this);
      }
      hasQueue() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initQueue() {
        capnp_ts_1.Struct.setUint16(0, 13, this);
        return capnp_ts_1.Struct.initStructAt(1, ServiceDesignator2, this);
      }
      isQueue() {
        return capnp_ts_1.Struct.getUint16(0, this) === 13;
      }
      setQueue(value) {
        capnp_ts_1.Struct.setUint16(0, 13, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      getFromEnvironment() {
        capnp_ts_1.Struct.testWhich("fromEnvironment", capnp_ts_1.Struct.getUint16(0, this), 14, this);
        return capnp_ts_1.Struct.getText(1, this);
      }
      isFromEnvironment() {
        return capnp_ts_1.Struct.getUint16(0, this) === 14;
      }
      setFromEnvironment(value) {
        capnp_ts_1.Struct.setUint16(0, 14, this);
        capnp_ts_1.Struct.setText(1, value, this);
      }
      adoptAnalyticsEngine(value) {
        capnp_ts_1.Struct.setUint16(0, 15, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownAnalyticsEngine() {
        return capnp_ts_1.Struct.disown(this.getAnalyticsEngine());
      }
      getAnalyticsEngine() {
        capnp_ts_1.Struct.testWhich("analyticsEngine", capnp_ts_1.Struct.getUint16(0, this), 15, this);
        return capnp_ts_1.Struct.getStruct(1, ServiceDesignator2, this);
      }
      hasAnalyticsEngine() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initAnalyticsEngine() {
        capnp_ts_1.Struct.setUint16(0, 15, this);
        return capnp_ts_1.Struct.initStructAt(1, ServiceDesignator2, this);
      }
      isAnalyticsEngine() {
        return capnp_ts_1.Struct.getUint16(0, this) === 15;
      }
      setAnalyticsEngine(value) {
        capnp_ts_1.Struct.setUint16(0, 15, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      toString() {
        return "Worker_Binding_" + super.toString();
      }
      which() {
        return capnp_ts_1.Struct.getUint16(0, this);
      }
    };
    exports.Worker_Binding = Worker_Binding3;
    Worker_Binding3.UNSPECIFIED = Worker_Binding_Which.UNSPECIFIED;
    Worker_Binding3.PARAMETER = Worker_Binding_Which.PARAMETER;
    Worker_Binding3.TEXT = Worker_Binding_Which.TEXT;
    Worker_Binding3.DATA = Worker_Binding_Which.DATA;
    Worker_Binding3.JSON = Worker_Binding_Which.JSON;
    Worker_Binding3.WASM_MODULE = Worker_Binding_Which.WASM_MODULE;
    Worker_Binding3.CRYPTO_KEY = Worker_Binding_Which.CRYPTO_KEY;
    Worker_Binding3.SERVICE = Worker_Binding_Which.SERVICE;
    Worker_Binding3.DURABLE_OBJECT_NAMESPACE = Worker_Binding_Which.DURABLE_OBJECT_NAMESPACE;
    Worker_Binding3.KV_NAMESPACE = Worker_Binding_Which.KV_NAMESPACE;
    Worker_Binding3.R2BUCKET = Worker_Binding_Which.R2BUCKET;
    Worker_Binding3.R2ADMIN = Worker_Binding_Which.R2ADMIN;
    Worker_Binding3.WRAPPED = Worker_Binding_Which.WRAPPED;
    Worker_Binding3.QUEUE = Worker_Binding_Which.QUEUE;
    Worker_Binding3.FROM_ENVIRONMENT = Worker_Binding_Which.FROM_ENVIRONMENT;
    Worker_Binding3.ANALYTICS_ENGINE = Worker_Binding_Which.ANALYTICS_ENGINE;
    Worker_Binding3.Type = Worker_Binding_Type;
    Worker_Binding3.DurableObjectNamespaceDesignator = Worker_Binding_DurableObjectNamespaceDesignator;
    Worker_Binding3.CryptoKey = Worker_Binding_CryptoKey;
    Worker_Binding3.WrappedBinding = Worker_Binding_WrappedBinding;
    Worker_Binding3._capnp = { displayName: "Binding", id: "8e7e492fd7e35f3e", size: new capnp_ts_1.ObjectSize(8, 2) };
    var Worker_DurableObjectNamespace_Which;
    (function(Worker_DurableObjectNamespace_Which2) {
      Worker_DurableObjectNamespace_Which2[Worker_DurableObjectNamespace_Which2["UNIQUE_KEY"] = 0] = "UNIQUE_KEY";
      Worker_DurableObjectNamespace_Which2[Worker_DurableObjectNamespace_Which2["EPHEMERAL_LOCAL"] = 1] = "EPHEMERAL_LOCAL";
    })(Worker_DurableObjectNamespace_Which = exports.Worker_DurableObjectNamespace_Which || (exports.Worker_DurableObjectNamespace_Which = {}));
    var Worker_DurableObjectNamespace = class extends capnp_ts_1.Struct {
      getClassName() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setClassName(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getUniqueKey() {
        capnp_ts_1.Struct.testWhich("uniqueKey", capnp_ts_1.Struct.getUint16(0, this), 0, this);
        return capnp_ts_1.Struct.getText(1, this);
      }
      isUniqueKey() {
        return capnp_ts_1.Struct.getUint16(0, this) === 0;
      }
      setUniqueKey(value) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        capnp_ts_1.Struct.setText(1, value, this);
      }
      isEphemeralLocal() {
        return capnp_ts_1.Struct.getUint16(0, this) === 1;
      }
      setEphemeralLocal() {
        capnp_ts_1.Struct.setUint16(0, 1, this);
      }
      toString() {
        return "Worker_DurableObjectNamespace_" + super.toString();
      }
      which() {
        return capnp_ts_1.Struct.getUint16(0, this);
      }
    };
    exports.Worker_DurableObjectNamespace = Worker_DurableObjectNamespace;
    Worker_DurableObjectNamespace.UNIQUE_KEY = Worker_DurableObjectNamespace_Which.UNIQUE_KEY;
    Worker_DurableObjectNamespace.EPHEMERAL_LOCAL = Worker_DurableObjectNamespace_Which.EPHEMERAL_LOCAL;
    Worker_DurableObjectNamespace._capnp = { displayName: "DurableObjectNamespace", id: "b429dd547d15747d", size: new capnp_ts_1.ObjectSize(8, 2) };
    var Worker_DurableObjectStorage_Which;
    (function(Worker_DurableObjectStorage_Which2) {
      Worker_DurableObjectStorage_Which2[Worker_DurableObjectStorage_Which2["NONE"] = 0] = "NONE";
      Worker_DurableObjectStorage_Which2[Worker_DurableObjectStorage_Which2["IN_MEMORY"] = 1] = "IN_MEMORY";
      Worker_DurableObjectStorage_Which2[Worker_DurableObjectStorage_Which2["LOCAL_DISK"] = 2] = "LOCAL_DISK";
    })(Worker_DurableObjectStorage_Which = exports.Worker_DurableObjectStorage_Which || (exports.Worker_DurableObjectStorage_Which = {}));
    var Worker_DurableObjectStorage = class extends capnp_ts_1.Struct {
      isNone() {
        return capnp_ts_1.Struct.getUint16(2, this) === 0;
      }
      setNone() {
        capnp_ts_1.Struct.setUint16(2, 0, this);
      }
      isInMemory() {
        return capnp_ts_1.Struct.getUint16(2, this) === 1;
      }
      setInMemory() {
        capnp_ts_1.Struct.setUint16(2, 1, this);
      }
      getLocalDisk() {
        capnp_ts_1.Struct.testWhich("localDisk", capnp_ts_1.Struct.getUint16(2, this), 2, this);
        return capnp_ts_1.Struct.getText(8, this);
      }
      isLocalDisk() {
        return capnp_ts_1.Struct.getUint16(2, this) === 2;
      }
      setLocalDisk(value) {
        capnp_ts_1.Struct.setUint16(2, 2, this);
        capnp_ts_1.Struct.setText(8, value, this);
      }
      toString() {
        return "Worker_DurableObjectStorage_" + super.toString();
      }
      which() {
        return capnp_ts_1.Struct.getUint16(2, this);
      }
    };
    exports.Worker_DurableObjectStorage = Worker_DurableObjectStorage;
    Worker_DurableObjectStorage.NONE = Worker_DurableObjectStorage_Which.NONE;
    Worker_DurableObjectStorage.IN_MEMORY = Worker_DurableObjectStorage_Which.IN_MEMORY;
    Worker_DurableObjectStorage.LOCAL_DISK = Worker_DurableObjectStorage_Which.LOCAL_DISK;
    Worker_DurableObjectStorage._capnp = { displayName: "durableObjectStorage", id: "cc72b3faa57827d4", size: new capnp_ts_1.ObjectSize(8, 9) };
    var Worker_Which;
    (function(Worker_Which2) {
      Worker_Which2[Worker_Which2["MODULES"] = 0] = "MODULES";
      Worker_Which2[Worker_Which2["SERVICE_WORKER_SCRIPT"] = 1] = "SERVICE_WORKER_SCRIPT";
      Worker_Which2[Worker_Which2["INHERIT"] = 2] = "INHERIT";
    })(Worker_Which = exports.Worker_Which || (exports.Worker_Which = {}));
    var Worker2 = class extends capnp_ts_1.Struct {
      adoptModules(value) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      disownModules() {
        return capnp_ts_1.Struct.disown(this.getModules());
      }
      getModules() {
        capnp_ts_1.Struct.testWhich("modules", capnp_ts_1.Struct.getUint16(0, this), 0, this);
        return capnp_ts_1.Struct.getList(0, Worker2._Modules, this);
      }
      hasModules() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(0, this));
      }
      initModules(length) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        return capnp_ts_1.Struct.initList(0, Worker2._Modules, length, this);
      }
      isModules() {
        return capnp_ts_1.Struct.getUint16(0, this) === 0;
      }
      setModules(value) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      getServiceWorkerScript() {
        capnp_ts_1.Struct.testWhich("serviceWorkerScript", capnp_ts_1.Struct.getUint16(0, this), 1, this);
        return capnp_ts_1.Struct.getText(0, this);
      }
      isServiceWorkerScript() {
        return capnp_ts_1.Struct.getUint16(0, this) === 1;
      }
      setServiceWorkerScript(value) {
        capnp_ts_1.Struct.setUint16(0, 1, this);
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getInherit() {
        capnp_ts_1.Struct.testWhich("inherit", capnp_ts_1.Struct.getUint16(0, this), 2, this);
        return capnp_ts_1.Struct.getText(0, this);
      }
      isInherit() {
        return capnp_ts_1.Struct.getUint16(0, this) === 2;
      }
      setInherit(value) {
        capnp_ts_1.Struct.setUint16(0, 2, this);
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getCompatibilityDate() {
        return capnp_ts_1.Struct.getText(1, this);
      }
      setCompatibilityDate(value) {
        capnp_ts_1.Struct.setText(1, value, this);
      }
      adoptCompatibilityFlags(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      disownCompatibilityFlags() {
        return capnp_ts_1.Struct.disown(this.getCompatibilityFlags());
      }
      getCompatibilityFlags() {
        return capnp_ts_1.Struct.getList(2, capnp.TextList, this);
      }
      hasCompatibilityFlags() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(2, this));
      }
      initCompatibilityFlags(length) {
        return capnp_ts_1.Struct.initList(2, capnp.TextList, length, this);
      }
      setCompatibilityFlags(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      adoptBindings(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(3, this));
      }
      disownBindings() {
        return capnp_ts_1.Struct.disown(this.getBindings());
      }
      getBindings() {
        return capnp_ts_1.Struct.getList(3, Worker2._Bindings, this);
      }
      hasBindings() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(3, this));
      }
      initBindings(length) {
        return capnp_ts_1.Struct.initList(3, Worker2._Bindings, length, this);
      }
      setBindings(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(3, this));
      }
      adoptGlobalOutbound(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(4, this));
      }
      disownGlobalOutbound() {
        return capnp_ts_1.Struct.disown(this.getGlobalOutbound());
      }
      getGlobalOutbound() {
        return capnp_ts_1.Struct.getStruct(4, ServiceDesignator2, this, Worker2._capnp.defaultGlobalOutbound);
      }
      hasGlobalOutbound() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(4, this));
      }
      initGlobalOutbound() {
        return capnp_ts_1.Struct.initStructAt(4, ServiceDesignator2, this);
      }
      setGlobalOutbound(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(4, this));
      }
      adoptCacheApiOutbound(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(7, this));
      }
      disownCacheApiOutbound() {
        return capnp_ts_1.Struct.disown(this.getCacheApiOutbound());
      }
      getCacheApiOutbound() {
        return capnp_ts_1.Struct.getStruct(7, ServiceDesignator2, this);
      }
      hasCacheApiOutbound() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(7, this));
      }
      initCacheApiOutbound() {
        return capnp_ts_1.Struct.initStructAt(7, ServiceDesignator2, this);
      }
      setCacheApiOutbound(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(7, this));
      }
      adoptDurableObjectNamespaces(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(5, this));
      }
      disownDurableObjectNamespaces() {
        return capnp_ts_1.Struct.disown(this.getDurableObjectNamespaces());
      }
      getDurableObjectNamespaces() {
        return capnp_ts_1.Struct.getList(5, Worker2._DurableObjectNamespaces, this);
      }
      hasDurableObjectNamespaces() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(5, this));
      }
      initDurableObjectNamespaces(length) {
        return capnp_ts_1.Struct.initList(5, Worker2._DurableObjectNamespaces, length, this);
      }
      setDurableObjectNamespaces(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(5, this));
      }
      getDurableObjectUniqueKeyModifier() {
        return capnp_ts_1.Struct.getText(6, this);
      }
      setDurableObjectUniqueKeyModifier(value) {
        capnp_ts_1.Struct.setText(6, value, this);
      }
      getDurableObjectStorage() {
        return capnp_ts_1.Struct.getAs(Worker_DurableObjectStorage, this);
      }
      initDurableObjectStorage() {
        return capnp_ts_1.Struct.getAs(Worker_DurableObjectStorage, this);
      }
      toString() {
        return "Worker_" + super.toString();
      }
      which() {
        return capnp_ts_1.Struct.getUint16(0, this);
      }
    };
    exports.Worker = Worker2;
    Worker2.MODULES = Worker_Which.MODULES;
    Worker2.SERVICE_WORKER_SCRIPT = Worker_Which.SERVICE_WORKER_SCRIPT;
    Worker2.INHERIT = Worker_Which.INHERIT;
    Worker2.Module = Worker_Module3;
    Worker2.Binding = Worker_Binding3;
    Worker2.DurableObjectNamespace = Worker_DurableObjectNamespace;
    Worker2._capnp = { displayName: "Worker", id: "acfa77e88fd97d1c", size: new capnp_ts_1.ObjectSize(8, 9), defaultGlobalOutbound: capnp.readRawPointer(new Uint8Array([16, 5, 64, 2, 17, 5, 74, 0, 0, 255, 105, 110, 116, 101, 114, 110, 101, 116, 0, 0, 0]).buffer) };
    var ExternalServer_Https = class extends capnp_ts_1.Struct {
      adoptOptions(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownOptions() {
        return capnp_ts_1.Struct.disown(this.getOptions());
      }
      getOptions() {
        return capnp_ts_1.Struct.getStruct(1, HttpOptions, this);
      }
      hasOptions() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initOptions() {
        return capnp_ts_1.Struct.initStructAt(1, HttpOptions, this);
      }
      setOptions(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptTlsOptions(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      disownTlsOptions() {
        return capnp_ts_1.Struct.disown(this.getTlsOptions());
      }
      getTlsOptions() {
        return capnp_ts_1.Struct.getStruct(2, TlsOptions, this);
      }
      hasTlsOptions() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(2, this));
      }
      initTlsOptions() {
        return capnp_ts_1.Struct.initStructAt(2, TlsOptions, this);
      }
      setTlsOptions(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      getCertificateHost() {
        return capnp_ts_1.Struct.getText(3, this);
      }
      setCertificateHost(value) {
        capnp_ts_1.Struct.setText(3, value, this);
      }
      toString() {
        return "ExternalServer_Https_" + super.toString();
      }
    };
    exports.ExternalServer_Https = ExternalServer_Https;
    ExternalServer_Https._capnp = { displayName: "https", id: "ac37e02afd3dc6db", size: new capnp_ts_1.ObjectSize(8, 4) };
    var ExternalServer_Which;
    (function(ExternalServer_Which2) {
      ExternalServer_Which2[ExternalServer_Which2["HTTP"] = 0] = "HTTP";
      ExternalServer_Which2[ExternalServer_Which2["HTTPS"] = 1] = "HTTPS";
    })(ExternalServer_Which = exports.ExternalServer_Which || (exports.ExternalServer_Which = {}));
    var ExternalServer2 = class extends capnp_ts_1.Struct {
      getAddress() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setAddress(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      adoptHttp(value) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownHttp() {
        return capnp_ts_1.Struct.disown(this.getHttp());
      }
      getHttp() {
        capnp_ts_1.Struct.testWhich("http", capnp_ts_1.Struct.getUint16(0, this), 0, this);
        return capnp_ts_1.Struct.getStruct(1, HttpOptions, this);
      }
      hasHttp() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initHttp() {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        return capnp_ts_1.Struct.initStructAt(1, HttpOptions, this);
      }
      isHttp() {
        return capnp_ts_1.Struct.getUint16(0, this) === 0;
      }
      setHttp(value) {
        capnp_ts_1.Struct.setUint16(0, 0, this);
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      getHttps() {
        capnp_ts_1.Struct.testWhich("https", capnp_ts_1.Struct.getUint16(0, this), 1, this);
        return capnp_ts_1.Struct.getAs(ExternalServer_Https, this);
      }
      initHttps() {
        capnp_ts_1.Struct.setUint16(0, 1, this);
        return capnp_ts_1.Struct.getAs(ExternalServer_Https, this);
      }
      isHttps() {
        return capnp_ts_1.Struct.getUint16(0, this) === 1;
      }
      setHttps() {
        capnp_ts_1.Struct.setUint16(0, 1, this);
      }
      toString() {
        return "ExternalServer_" + super.toString();
      }
      which() {
        return capnp_ts_1.Struct.getUint16(0, this);
      }
    };
    exports.ExternalServer = ExternalServer2;
    ExternalServer2.HTTP = ExternalServer_Which.HTTP;
    ExternalServer2.HTTPS = ExternalServer_Which.HTTPS;
    ExternalServer2._capnp = { displayName: "ExternalServer", id: "ff209f9aa352f5a4", size: new capnp_ts_1.ObjectSize(8, 4) };
    var Network = class extends capnp_ts_1.Struct {
      adoptAllow(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      disownAllow() {
        return capnp_ts_1.Struct.disown(this.getAllow());
      }
      getAllow() {
        return capnp_ts_1.Struct.getList(0, capnp.TextList, this, Network._capnp.defaultAllow);
      }
      hasAllow() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(0, this));
      }
      initAllow(length) {
        return capnp_ts_1.Struct.initList(0, capnp.TextList, length, this);
      }
      setAllow(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      adoptDeny(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownDeny() {
        return capnp_ts_1.Struct.disown(this.getDeny());
      }
      getDeny() {
        return capnp_ts_1.Struct.getList(1, capnp.TextList, this);
      }
      hasDeny() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initDeny(length) {
        return capnp_ts_1.Struct.initList(1, capnp.TextList, length, this);
      }
      setDeny(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      adoptTlsOptions(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      disownTlsOptions() {
        return capnp_ts_1.Struct.disown(this.getTlsOptions());
      }
      getTlsOptions() {
        return capnp_ts_1.Struct.getStruct(2, TlsOptions, this);
      }
      hasTlsOptions() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(2, this));
      }
      initTlsOptions() {
        return capnp_ts_1.Struct.initStructAt(2, TlsOptions, this);
      }
      setTlsOptions(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      toString() {
        return "Network_" + super.toString();
      }
    };
    exports.Network = Network;
    Network._capnp = { displayName: "Network", id: "fa42244f950c9b9c", size: new capnp_ts_1.ObjectSize(0, 3), defaultAllow: capnp.readRawPointer(new Uint8Array([16, 3, 17, 1, 14, 17, 1, 58, 63, 112, 117, 98, 108, 105, 99]).buffer) };
    var DiskDirectory = class extends capnp_ts_1.Struct {
      getPath() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setPath(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getWritable() {
        return capnp_ts_1.Struct.getBit(0, this, DiskDirectory._capnp.defaultWritable);
      }
      setWritable(value) {
        capnp_ts_1.Struct.setBit(0, value, this);
      }
      getAllowDotfiles() {
        return capnp_ts_1.Struct.getBit(1, this, DiskDirectory._capnp.defaultAllowDotfiles);
      }
      setAllowDotfiles(value) {
        capnp_ts_1.Struct.setBit(1, value, this);
      }
      toString() {
        return "DiskDirectory_" + super.toString();
      }
    };
    exports.DiskDirectory = DiskDirectory;
    DiskDirectory._capnp = { displayName: "DiskDirectory", id: "9048ab22835f51c3", size: new capnp_ts_1.ObjectSize(8, 1), defaultWritable: capnp.getBitMask(false, 0), defaultAllowDotfiles: capnp.getBitMask(false, 1) };
    var HttpOptions_Style2;
    (function(HttpOptions_Style3) {
      HttpOptions_Style3[HttpOptions_Style3["HOST"] = 0] = "HOST";
      HttpOptions_Style3[HttpOptions_Style3["PROXY"] = 1] = "PROXY";
    })(HttpOptions_Style2 = exports.HttpOptions_Style || (exports.HttpOptions_Style = {}));
    var HttpOptions_Header = class extends capnp_ts_1.Struct {
      getName() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setName(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getValue() {
        return capnp_ts_1.Struct.getText(1, this);
      }
      setValue(value) {
        capnp_ts_1.Struct.setText(1, value, this);
      }
      toString() {
        return "HttpOptions_Header_" + super.toString();
      }
    };
    exports.HttpOptions_Header = HttpOptions_Header;
    HttpOptions_Header._capnp = { displayName: "Header", id: "dc0394b5a6f3417e", size: new capnp_ts_1.ObjectSize(0, 2) };
    var HttpOptions = class extends capnp_ts_1.Struct {
      getStyle() {
        return capnp_ts_1.Struct.getUint16(0, this, HttpOptions._capnp.defaultStyle);
      }
      setStyle(value) {
        capnp_ts_1.Struct.setUint16(0, value, this);
      }
      getForwardedProtoHeader() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setForwardedProtoHeader(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getCfBlobHeader() {
        return capnp_ts_1.Struct.getText(1, this);
      }
      setCfBlobHeader(value) {
        capnp_ts_1.Struct.setText(1, value, this);
      }
      adoptInjectRequestHeaders(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      disownInjectRequestHeaders() {
        return capnp_ts_1.Struct.disown(this.getInjectRequestHeaders());
      }
      getInjectRequestHeaders() {
        return capnp_ts_1.Struct.getList(2, HttpOptions._InjectRequestHeaders, this);
      }
      hasInjectRequestHeaders() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(2, this));
      }
      initInjectRequestHeaders(length) {
        return capnp_ts_1.Struct.initList(2, HttpOptions._InjectRequestHeaders, length, this);
      }
      setInjectRequestHeaders(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(2, this));
      }
      adoptInjectResponseHeaders(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(3, this));
      }
      disownInjectResponseHeaders() {
        return capnp_ts_1.Struct.disown(this.getInjectResponseHeaders());
      }
      getInjectResponseHeaders() {
        return capnp_ts_1.Struct.getList(3, HttpOptions._InjectResponseHeaders, this);
      }
      hasInjectResponseHeaders() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(3, this));
      }
      initInjectResponseHeaders(length) {
        return capnp_ts_1.Struct.initList(3, HttpOptions._InjectResponseHeaders, length, this);
      }
      setInjectResponseHeaders(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(3, this));
      }
      toString() {
        return "HttpOptions_" + super.toString();
      }
    };
    exports.HttpOptions = HttpOptions;
    HttpOptions.Style = HttpOptions_Style2;
    HttpOptions.Header = HttpOptions_Header;
    HttpOptions._capnp = { displayName: "HttpOptions", id: "aa8dc6885da78f19", size: new capnp_ts_1.ObjectSize(8, 4), defaultStyle: capnp.getUint16Mask(0) };
    var TlsOptions_Keypair = class extends capnp_ts_1.Struct {
      getPrivateKey() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setPrivateKey(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getCertificateChain() {
        return capnp_ts_1.Struct.getText(1, this);
      }
      setCertificateChain(value) {
        capnp_ts_1.Struct.setText(1, value, this);
      }
      toString() {
        return "TlsOptions_Keypair_" + super.toString();
      }
    };
    exports.TlsOptions_Keypair = TlsOptions_Keypair;
    TlsOptions_Keypair._capnp = { displayName: "Keypair", id: "f546bf2d5d8bd13e", size: new capnp_ts_1.ObjectSize(0, 2) };
    var TlsOptions_Version2;
    (function(TlsOptions_Version3) {
      TlsOptions_Version3[TlsOptions_Version3["GOOD_DEFAULT"] = 0] = "GOOD_DEFAULT";
      TlsOptions_Version3[TlsOptions_Version3["SSL3"] = 1] = "SSL3";
      TlsOptions_Version3[TlsOptions_Version3["TLS1DOT0"] = 2] = "TLS1DOT0";
      TlsOptions_Version3[TlsOptions_Version3["TLS1DOT1"] = 3] = "TLS1DOT1";
      TlsOptions_Version3[TlsOptions_Version3["TLS1DOT2"] = 4] = "TLS1DOT2";
      TlsOptions_Version3[TlsOptions_Version3["TLS1DOT3"] = 5] = "TLS1DOT3";
    })(TlsOptions_Version2 = exports.TlsOptions_Version || (exports.TlsOptions_Version = {}));
    var TlsOptions = class extends capnp_ts_1.Struct {
      adoptKeypair(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      disownKeypair() {
        return capnp_ts_1.Struct.disown(this.getKeypair());
      }
      getKeypair() {
        return capnp_ts_1.Struct.getStruct(0, TlsOptions_Keypair, this);
      }
      hasKeypair() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(0, this));
      }
      initKeypair() {
        return capnp_ts_1.Struct.initStructAt(0, TlsOptions_Keypair, this);
      }
      setKeypair(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      getRequireClientCerts() {
        return capnp_ts_1.Struct.getBit(0, this, TlsOptions._capnp.defaultRequireClientCerts);
      }
      setRequireClientCerts(value) {
        capnp_ts_1.Struct.setBit(0, value, this);
      }
      getTrustBrowserCas() {
        return capnp_ts_1.Struct.getBit(1, this, TlsOptions._capnp.defaultTrustBrowserCas);
      }
      setTrustBrowserCas(value) {
        capnp_ts_1.Struct.setBit(1, value, this);
      }
      adoptTrustedCertificates(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      disownTrustedCertificates() {
        return capnp_ts_1.Struct.disown(this.getTrustedCertificates());
      }
      getTrustedCertificates() {
        return capnp_ts_1.Struct.getList(1, capnp.TextList, this);
      }
      hasTrustedCertificates() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(1, this));
      }
      initTrustedCertificates(length) {
        return capnp_ts_1.Struct.initList(1, capnp.TextList, length, this);
      }
      setTrustedCertificates(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(1, this));
      }
      getMinVersion() {
        return capnp_ts_1.Struct.getUint16(2, this, TlsOptions._capnp.defaultMinVersion);
      }
      setMinVersion(value) {
        capnp_ts_1.Struct.setUint16(2, value, this);
      }
      getCipherList() {
        return capnp_ts_1.Struct.getText(2, this);
      }
      setCipherList(value) {
        capnp_ts_1.Struct.setText(2, value, this);
      }
      toString() {
        return "TlsOptions_" + super.toString();
      }
    };
    exports.TlsOptions = TlsOptions;
    TlsOptions.Keypair = TlsOptions_Keypair;
    TlsOptions.Version = TlsOptions_Version2;
    TlsOptions._capnp = { displayName: "TlsOptions", id: "aabb3c3778ac4311", size: new capnp_ts_1.ObjectSize(8, 3), defaultRequireClientCerts: capnp.getBitMask(false, 0), defaultTrustBrowserCas: capnp.getBitMask(false, 1), defaultMinVersion: capnp.getUint16Mask(0) };
    var Extension_Module = class extends capnp_ts_1.Struct {
      getName() {
        return capnp_ts_1.Struct.getText(0, this);
      }
      setName(value) {
        capnp_ts_1.Struct.setText(0, value, this);
      }
      getInternal() {
        return capnp_ts_1.Struct.getBit(0, this, Extension_Module._capnp.defaultInternal);
      }
      setInternal(value) {
        capnp_ts_1.Struct.setBit(0, value, this);
      }
      getEsModule() {
        return capnp_ts_1.Struct.getText(1, this);
      }
      setEsModule(value) {
        capnp_ts_1.Struct.setText(1, value, this);
      }
      toString() {
        return "Extension_Module_" + super.toString();
      }
    };
    exports.Extension_Module = Extension_Module;
    Extension_Module._capnp = { displayName: "Module", id: "d5d16e76fdedc37d", size: new capnp_ts_1.ObjectSize(8, 2), defaultInternal: capnp.getBitMask(false, 0) };
    var Extension2 = class extends capnp_ts_1.Struct {
      adoptModules(value) {
        capnp_ts_1.Struct.adopt(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      disownModules() {
        return capnp_ts_1.Struct.disown(this.getModules());
      }
      getModules() {
        return capnp_ts_1.Struct.getList(0, Extension2._Modules, this);
      }
      hasModules() {
        return !capnp_ts_1.Struct.isNull(capnp_ts_1.Struct.getPointer(0, this));
      }
      initModules(length) {
        return capnp_ts_1.Struct.initList(0, Extension2._Modules, length, this);
      }
      setModules(value) {
        capnp_ts_1.Struct.copyFrom(value, capnp_ts_1.Struct.getPointer(0, this));
      }
      toString() {
        return "Extension_" + super.toString();
      }
    };
    exports.Extension = Extension2;
    Extension2.Module = Extension_Module;
    Extension2._capnp = { displayName: "Extension", id: "e390128a861973a6", size: new capnp_ts_1.ObjectSize(0, 1) };
    Config3._Services = capnp.CompositeList(Service3);
    Config3._Sockets = capnp.CompositeList(Socket2);
    Config3._Extensions = capnp.CompositeList(Extension2);
    Worker_Binding_WrappedBinding._InnerBindings = capnp.CompositeList(Worker_Binding3);
    Worker2._Modules = capnp.CompositeList(Worker_Module3);
    Worker2._Bindings = capnp.CompositeList(Worker_Binding3);
    Worker2._DurableObjectNamespaces = capnp.CompositeList(Worker_DurableObjectNamespace);
    HttpOptions._InjectRequestHeaders = capnp.CompositeList(HttpOptions_Header);
    HttpOptions._InjectResponseHeaders = capnp.CompositeList(HttpOptions_Header);
    Extension2._Modules = capnp.CompositeList(Extension_Module);
  }
});

// node_modules/semiver/dist/semiver.js
var require_semiver = __commonJS({
  "node_modules/semiver/dist/semiver.js"(exports, module2) {
    var fn = new Intl.Collator(0, { numeric: 1 }).compare;
    module2.exports = function(a, b, bool) {
      a = a.split(".");
      b = b.split(".");
      return fn(a[0], b[0]) || fn(a[1], b[1]) || (b[2] = b.slice(2).join("."), bool = /[.-]/.test(a[2] = a.slice(2).join(".")), bool == /[.-]/.test(b[2]) ? fn(a[2], b[2]) : bool ? -1 : 1);
    };
  }
});

// packages/miniflare/src/index.ts
var src_exports = {};
__export(src_exports, {
  BASE64_REGEXP: () => BASE64_REGEXP,
  BINDING_TEXT_NAMESPACE: () => BINDING_TEXT_NAMESPACE,
  BINDING_TEXT_PERSIST: () => BINDING_TEXT_PERSIST,
  BINDING_TEXT_PLUGIN: () => BINDING_TEXT_PLUGIN,
  Base64DataSchema: () => Base64DataSchema,
  CACHE_LOOPBACK_SCRIPT: () => CACHE_LOOPBACK_SCRIPT,
  CACHE_PLUGIN: () => CACHE_PLUGIN,
  CACHE_PLUGIN_NAME: () => CACHE_PLUGIN_NAME,
  CORE_PLUGIN: () => CORE_PLUGIN,
  CORE_PLUGIN_NAME: () => CORE_PLUGIN_NAME2,
  CacheGateway: () => CacheGateway,
  CacheOptionsSchema: () => CacheOptionsSchema,
  CacheSharedOptionsSchema: () => CacheSharedOptionsSchema,
  CfHeader: () => CfHeader,
  CloseEvent: () => CloseEvent,
  CloudflareFetchSchema: () => CloudflareFetchSchema,
  CoreBindings: () => CoreBindings,
  CoreHeaders: () => CoreHeaders,
  CoreOptionsSchema: () => CoreOptionsSchema,
  CoreSharedOptionsSchema: () => CoreSharedOptionsSchema,
  D1Error: () => D1Error,
  D1Gateway: () => D1Gateway,
  D1OptionsSchema: () => D1OptionsSchema,
  D1QuerySchema: () => D1QuerySchema,
  D1SharedOptionsSchema: () => D1SharedOptionsSchema,
  D1SingleQuerySchema: () => D1SingleQuerySchema,
  D1ValueSchema: () => D1ValueSchema,
  D1_PLUGIN: () => D1_PLUGIN,
  D1_PLUGIN_NAME: () => D1_PLUGIN_NAME,
  DEFAULT_PERSIST_ROOT: () => DEFAULT_PERSIST_ROOT,
  DELETE: () => DELETE,
  DURABLE_OBJECTS_PLUGIN: () => DURABLE_OBJECTS_PLUGIN,
  DURABLE_OBJECTS_PLUGIN_NAME: () => DURABLE_OBJECTS_PLUGIN_NAME,
  DURABLE_OBJECTS_STORAGE_SERVICE_NAME: () => DURABLE_OBJECTS_STORAGE_SERVICE_NAME,
  DateSchema: () => DateSchema,
  DeferredPromise: () => DeferredPromise,
  DurableObjectsOptionsSchema: () => DurableObjectsOptionsSchema,
  DurableObjectsSharedOptionsSchema: () => DurableObjectsSharedOptionsSchema,
  ErrorEvent: () => ErrorEvent,
  File: () => import_undici8.File,
  FileBlobStore: () => FileBlobStore,
  FormData: () => import_undici8.FormData,
  GET: () => GET,
  GatewayFactory: () => GatewayFactory,
  GatewayMessageSchema: () => GatewayMessageSchema,
  HEAD: () => HEAD,
  HEADER_CF_BLOB: () => HEADER_CF_BLOB,
  HEADER_PERSIST: () => HEADER_PERSIST,
  HEX_REGEXP: () => HEX_REGEXP,
  Headers: () => import_undici8.Headers,
  HexDataSchema: () => HexDataSchema,
  HttpError: () => HttpError,
  HttpOptions_Style: () => import_workerd_capnp.HttpOptions_Style,
  IgnoreSourcePredicateSchema: () => IgnoreSourcePredicateSchema,
  InternalR2Object: () => InternalR2Object,
  InternalR2ObjectBody: () => InternalR2ObjectBody,
  JsonSchema: () => JsonSchema,
  KVError: () => KVError,
  KVGateway: () => KVGateway,
  KVOptionsSchema: () => KVOptionsSchema,
  KVSharedOptionsSchema: () => KVSharedOptionsSchema,
  KV_PLUGIN: () => KV_PLUGIN,
  KV_PLUGIN_NAME: () => KV_PLUGIN_NAME,
  KeyValueStorage: () => KeyValueStorage,
  LiteralSchema: () => LiteralSchema,
  Log: () => Log,
  LogLevel: () => LogLevel,
  MemoryBlobStore: () => MemoryBlobStore,
  Message: () => Message2,
  MessageEvent: () => MessageEvent,
  Miniflare: () => Miniflare,
  MiniflareCoreError: () => MiniflareCoreError,
  MiniflareError: () => MiniflareError,
  ModuleDefinitionSchema: () => ModuleDefinitionSchema,
  ModuleRuleSchema: () => ModuleRuleSchema,
  ModuleRuleTypeSchema: () => ModuleRuleTypeSchema,
  MultipartUploadState: () => MultipartUploadState,
  Mutex: () => Mutex,
  NOOP_CACHE_SCRIPT: () => NOOP_CACHE_SCRIPT,
  NoOpLog: () => NoOpLog,
  PARAM_FILE_UNSANITISE: () => PARAM_FILE_UNSANITISE,
  PATCH: () => PATCH,
  PLUGINS: () => PLUGINS,
  PLUGIN_ENTRIES: () => PLUGIN_ENTRIES,
  POST: () => POST,
  PURGE: () => PURGE,
  PUT: () => PUT,
  PersistenceSchema: () => PersistenceSchema,
  ProxyAddresses: () => ProxyAddresses,
  ProxyClient: () => ProxyClient,
  ProxyOps: () => ProxyOps,
  QUEUES_PLUGIN: () => QUEUES_PLUGIN,
  QUEUES_PLUGIN_NAME: () => QUEUES_PLUGIN_NAME,
  QueueConsumerOptionsSchema: () => QueueConsumerOptionsSchema,
  QueueContentTypeSchema: () => QueueContentTypeSchema,
  QueuesError: () => QueuesError,
  QueuesGateway: () => QueuesGateway,
  QueuesHTTPError: () => QueuesHTTPError,
  QueuesOptionsSchema: () => QueuesOptionsSchema,
  R2AbortMultipartUploadRequestSchema: () => R2AbortMultipartUploadRequestSchema,
  R2BindingRequestSchema: () => R2BindingRequestSchema,
  R2ChecksumsSchema: () => R2ChecksumsSchema,
  R2CompleteMultipartUploadRequestSchema: () => R2CompleteMultipartUploadRequestSchema,
  R2ConditionalSchema: () => R2ConditionalSchema,
  R2CreateMultipartUploadRequestSchema: () => R2CreateMultipartUploadRequestSchema,
  R2DeleteRequestSchema: () => R2DeleteRequestSchema,
  R2EtagMatchSchema: () => R2EtagMatchSchema,
  R2EtagSchema: () => R2EtagSchema,
  R2Gateway: () => R2Gateway,
  R2GetRequestSchema: () => R2GetRequestSchema,
  R2HeadRequestSchema: () => R2HeadRequestSchema,
  R2HttpFieldsSchema: () => R2HttpFieldsSchema,
  R2ListRequestSchema: () => R2ListRequestSchema,
  R2OptionsSchema: () => R2OptionsSchema,
  R2PublishedPartSchema: () => R2PublishedPartSchema,
  R2PutRequestSchema: () => R2PutRequestSchema,
  R2RangeSchema: () => R2RangeSchema,
  R2SharedOptionsSchema: () => R2SharedOptionsSchema,
  R2UploadPartRequestSchema: () => R2UploadPartRequestSchema,
  R2_PLUGIN: () => R2_PLUGIN,
  R2_PLUGIN_NAME: () => R2_PLUGIN_NAME,
  RecordSchema: () => RecordSchema,
  Request: () => Request,
  Response: () => Response,
  ResponseInfoSchema: () => ResponseInfoSchema,
  Router: () => Router,
  RouterError: () => RouterError,
  Runtime: () => Runtime,
  SERVICE_ENTRY: () => SERVICE_ENTRY,
  SERVICE_LOOPBACK: () => SERVICE_LOOPBACK,
  SOCKET_ENTRY: () => SOCKET_ENTRY,
  SQL_SCHEMA: () => SQL_SCHEMA2,
  SourceMapRegistry: () => SourceMapRegistry,
  SourceOptionsSchema: () => SourceOptionsSchema,
  TlsOptions_Version: () => import_workerd_capnp.TlsOptions_Version,
  TypedEventTarget: () => TypedEventTarget,
  WORKER_BINDING_SERVICE_LOOPBACK: () => WORKER_BINDING_SERVICE_LOOPBACK,
  WaitGroup: () => WaitGroup,
  WebSocket: () => WebSocket,
  WebSocketPair: () => WebSocketPair,
  Worker_Binding_CryptoKey_Usage: () => import_workerd_capnp.Worker_Binding_CryptoKey_Usage,
  _HttpParser: () => _HttpParser,
  _QUEUES_COMPATIBLE_V8_VERSION: () => _QUEUES_COMPATIBLE_V8_VERSION,
  _RemoveTransformEncodingChunkedStream: () => _RemoveTransformEncodingChunkedStream,
  _initialiseInstanceRegistry: () => _initialiseInstanceRegistry,
  _parseRanges: () => _parseRanges,
  _testR2Conditional: () => _testR2Conditional,
  _transformsForContentEncoding: () => _transformsForContentEncoding,
  allowUnauthorizedAgent: () => allowUnauthorizedAgent,
  base64Decode: () => base64Decode,
  base64Encode: () => base64Encode,
  configureEntrySocket: () => configureEntrySocket,
  coupleWebSocket: () => coupleWebSocket,
  createArrayReadableStream: () => createArrayReadableStream,
  createFetchMock: () => createFetchMock,
  createFileReadableStream: () => createFileReadableStream,
  createFileStorage: () => createFileStorage,
  createFileWritableStream: () => createFileWritableStream,
  createHTTPReducers: () => createHTTPReducers,
  createHTTPRevivers: () => createHTTPRevivers,
  createMemoryStorage: () => createMemoryStorage,
  createMultipartArrayReadableStream: () => createMultipartArrayReadableStream,
  createMultipartFileReadableStream: () => createMultipartFileReadableStream,
  createReadableStream: () => createReadableStream,
  decodePersist: () => decodePersist,
  defaultClock: () => defaultClock,
  defaultTimers: () => defaultTimers,
  deserialiseRegExps: () => deserialiseRegExps,
  encodePersist: () => encodePersist,
  escapeLike: () => escapeLike,
  fetch: () => fetch2,
  formatResponse: () => formatResponse,
  getAccessibleHosts: () => getAccessibleHosts,
  getCacheServiceName: () => getCacheServiceName,
  getGlobalServices: () => getGlobalServices,
  globsToRegExps: () => globsToRegExps,
  isFetcherFetch: () => isFetcherFetch,
  isR2ObjectWriteHttpMetadata: () => isR2ObjectWriteHttpMetadata,
  isSitesRequest: () => isSitesRequest,
  kProxyNodeBinding: () => kProxyNodeBinding,
  kVoid: () => kVoid,
  lexicographicCompare: () => lexicographicCompare,
  matchRoutes: () => matchRoutes,
  maybeApply: () => maybeApply,
  maybeGetSitesManifestModule: () => maybeGetSitesManifestModule,
  maybeParseURL: () => maybeParseURL,
  millisToSeconds: () => millisToSeconds,
  namespaceEntries: () => namespaceEntries,
  namespaceKeys: () => namespaceKeys,
  nonCircularClone: () => nonCircularClone,
  normaliseDurableObject: () => normaliseDurableObject,
  parseRoutes: () => parseRoutes,
  parseWithReadableStreams: () => parseWithReadableStreams,
  pluginNamespacePersistWorker: () => pluginNamespacePersistWorker,
  prefixError: () => prefixError,
  prefixStream: () => prefixStream,
  readPrefix: () => readPrefix,
  sanitisePath: () => sanitisePath,
  secondsToMillis: () => secondsToMillis,
  serialiseRegExps: () => serialiseRegExps,
  serializeConfig: () => serializeConfig,
  stringifyWithStreams: () => stringifyWithStreams,
  structuredSerializableReducers: () => structuredSerializableReducers,
  structuredSerializableRevivers: () => structuredSerializableRevivers,
  supportedCompatibilityDate: () => import_workerd2.compatibilityDate,
  testRegExps: () => testRegExps,
  unwrapBYOBRequest: () => unwrapBYOBRequest,
  validateGetOptions: () => validateGetOptions,
  validateListOptions: () => validateListOptions,
  viewToArray: () => viewToArray,
  viewToBuffer: () => viewToBuffer,
  zAwaitable: () => zAwaitable
});
module.exports = __toCommonJS(src_exports);
var import_assert21 = __toESM(require("assert"));
var import_crypto8 = __toESM(require("crypto"));
var import_fs6 = __toESM(require("fs"));
var import_http20 = __toESM(require("http"));
var import_net = __toESM(require("net"));
var import_os3 = __toESM(require("os"));
var import_path13 = __toESM(require("path"));
var import_web11 = require("stream/web");
var import_zlib = __toESM(require("zlib"));
var import_exit_hook = __toESM(require("exit-hook"));
var import_stoppable = __toESM(require("stoppable"));
var import_ws3 = require("ws");
var import_zod21 = require("zod");

// packages/miniflare/src/cf.ts
var import_assert = __toESM(require("assert"));
var import_promises = require("fs/promises");
var import_path = __toESM(require("path"));
var import_colors = require("kleur/colors");
var import_undici = require("undici");
var defaultCfPath = import_path.default.resolve("node_modules", ".mf", "cf.json");
var defaultCfFetchEndpoint = "https://workers.cloudflare.com/cf.json";
var fallbackCf = {
  asOrganization: "",
  asn: 395747,
  colo: "DFW",
  city: "Austin",
  region: "Texas",
  regionCode: "TX",
  metroCode: "635",
  postalCode: "78701",
  country: "US",
  continent: "NA",
  timezone: "America/Chicago",
  latitude: "30.27130",
  longitude: "-97.74260",
  clientTcpRtt: 0,
  httpProtocol: "HTTP/1.1",
  requestPriority: "weight=192;exclusive=0",
  tlsCipher: "AEAD-AES128-GCM-SHA256",
  tlsVersion: "TLSv1.3",
  tlsClientAuth: {
    certPresented: "0",
    certVerified: "NONE",
    certRevoked: "0",
    certIssuerDN: "",
    certSubjectDN: "",
    certIssuerDNRFC2253: "",
    certSubjectDNRFC2253: "",
    certIssuerDNLegacy: "",
    certSubjectDNLegacy: "",
    certSerial: "",
    certIssuerSerial: "",
    certSKI: "",
    certIssuerSKI: "",
    certFingerprintSHA1: "",
    certFingerprintSHA256: "",
    certNotBefore: "",
    certNotAfter: ""
  },
  edgeRequestKeepAliveStatus: 0,
  hostMetadata: void 0,
  clientTrustScore: 99,
  botManagement: {
    corporateProxy: false,
    verifiedBot: false,
    ja3Hash: "25b4882c2bcb50cd6b469ff28c596742",
    staticResource: false,
    detectionIds: [],
    score: 99
  }
};
var DAY = 864e5;
var CF_DAYS = 30;
async function setupCf(log, cf) {
  if (!(cf ?? process.env.NODE_ENV !== "test")) {
    return fallbackCf;
  }
  if (typeof cf === "object") {
    return cf;
  }
  let cfPath = defaultCfPath;
  if (typeof cf === "string") {
    cfPath = cf;
  }
  try {
    const storedCf = JSON.parse(await (0, import_promises.readFile)(cfPath, "utf8"));
    const cfStat = await (0, import_promises.stat)(cfPath);
    (0, import_assert.default)(Date.now() - cfStat.mtimeMs <= CF_DAYS * DAY);
    return storedCf;
  } catch {
  }
  try {
    const res = await (0, import_undici.fetch)(defaultCfFetchEndpoint);
    const cfText = await res.text();
    const storedCf = JSON.parse(cfText);
    await (0, import_promises.mkdir)(import_path.default.dirname(cfPath), { recursive: true });
    await (0, import_promises.writeFile)(cfPath, cfText, "utf8");
    log.debug("Updated `Request.cf` object cache!");
    return storedCf;
  } catch (e) {
    log.warn(
      "Unable to fetch the `Request.cf` object! Falling back to a default placeholder...\n" + (0, import_colors.dim)(e.cause ? e.cause.stack : e.stack)
    );
    return fallbackCf;
  }
}

// packages/miniflare/src/http/fetch.ts
var import_undici4 = require("undici");
var import_ws2 = __toESM(require("ws"));

// packages/miniflare/src/shared/timers.ts
var defaultTimers = {
  now: () => Date.now(),
  setTimeout,
  clearTimeout,
  queueMicrotask
};
var defaultClock = defaultTimers.now;
function millisToSeconds(millis) {
  return Math.floor(millis / 1e3);
}
function secondsToMillis(seconds) {
  return seconds * 1e3;
}

// packages/miniflare/src/shared/data.ts
function lexicographicCompare(x, y) {
  if (x < y)
    return -1;
  if (x === y)
    return 0;
  return 1;
}
function nonCircularClone(value) {
  return JSON.parse(JSON.stringify(value));
}
function viewToArray(view) {
  return new Uint8Array(view.buffer, view.byteOffset, view.byteLength);
}
function viewToBuffer(view) {
  return view.buffer.slice(view.byteOffset, view.byteOffset + view.byteLength);
}
function base64Encode(value) {
  return Buffer.from(value, "utf8").toString("base64");
}
function base64Decode(encoded) {
  return Buffer.from(encoded, "base64").toString("utf8");
}
var dotRegexp = /(^|\/|\\)(\.+)(\/|\\|$)/g;
var illegalRegexp = /[?<>*"'^/\\:|\x00-\x1f\x80-\x9f]/g;
var windowsReservedRegexp = /^(con|prn|aux|nul|com[0-9]|lpt[0-9])(\..*)?$/i;
var leadingRegexp = /^[ /\\]+/;
var trailingRegexp = /[ /\\]+$/;
function dotReplacement(match, g1, g2, g3) {
  return `${g1}${"".padStart(g2.length, "_")}${g3}`;
}
function underscoreReplacement(match) {
  return "".padStart(match.length, "_");
}
function sanitisePath(unsafe) {
  return unsafe.replace(dotRegexp, dotReplacement).replace(dotRegexp, dotReplacement).replace(illegalRegexp, "_").replace(windowsReservedRegexp, "_").replace(leadingRegexp, underscoreReplacement).replace(trailingRegexp, underscoreReplacement).substring(0, 255);
}

// packages/miniflare/src/shared/error.ts
var MiniflareError = class extends Error {
  constructor(code, message, cause) {
    super(message);
    this.code = code;
    this.cause = cause;
    Object.setPrototypeOf(this, new.target.prototype);
    this.name = `${new.target.name} [${code}]`;
  }
};
var MiniflareCoreError = class extends MiniflareError {
};
var HttpError = class extends MiniflareError {
  constructor(code, message, cause) {
    super(code, message, cause);
  }
  toResponse() {
    return new Response(this.message, {
      status: this.code,
      // Custom statusMessage is required for runtime error messages
      statusText: this.message.substring(0, 512)
    });
  }
};

// packages/miniflare/src/shared/event.ts
var TypedEventTarget = class extends EventTarget {
  addEventListener(type, listener, options) {
    super.addEventListener(
      type,
      listener,
      options
    );
  }
  removeEventListener(type, listener, options) {
    super.removeEventListener(
      type,
      listener,
      options
    );
  }
  dispatchEvent(event) {
    return super.dispatchEvent(event);
  }
};

// packages/miniflare/src/shared/log.ts
var import_http2 = __toESM(require("http"));
var import_path2 = __toESM(require("path"));
var import_colors2 = require("kleur/colors");
var import_zod = require("zod");

// packages/miniflare/src/workers/core/constants.ts
var CoreHeaders = {
  CUSTOM_SERVICE: "MF-Custom-Service",
  ORIGINAL_URL: "MF-Original-URL",
  ERROR_STACK: "MF-Experimental-Error-Stack",
  ROUTE_OVERRIDE: "MF-Route-Override",
  CUSTOM_EVENT: "MF-Custom-Event",
  // API Proxy
  OP: "MF-Op",
  OP_TARGET: "MF-Op-Target",
  OP_KEY: "MF-Op-Key",
  OP_SYNC: "MF-Op-Sync",
  OP_STRINGIFIED_SIZE: "MF-Op-Stringified-Size",
  OP_RESULT_TYPE: "MF-Op-Result-Type"
};
var CoreBindings = {
  SERVICE_LOOPBACK: "MINIFLARE_LOOPBACK",
  SERVICE_USER_ROUTE_PREFIX: "MINIFLARE_USER_ROUTE_",
  SERVICE_USER_FALLBACK: "MINIFLARE_USER_FALLBACK",
  TEXT_CUSTOM_SERVICE: "MINIFLARE_CUSTOM_SERVICE",
  TEXT_UPSTREAM_URL: "MINIFLARE_UPSTREAM_URL",
  JSON_CF_BLOB: "CF_BLOB",
  JSON_ROUTES: "MINIFLARE_ROUTES",
  JSON_LOG_LEVEL: "MINIFLARE_LOG_LEVEL",
  DATA_LIVE_RELOAD_SCRIPT: "MINIFLARE_LIVE_RELOAD_SCRIPT",
  DURABLE_OBJECT_NAMESPACE_PROXY: "MINIFLARE_PROXY"
};
var LogLevel = /* @__PURE__ */ ((LogLevel2) => {
  LogLevel2[LogLevel2["NONE"] = 0] = "NONE";
  LogLevel2[LogLevel2["ERROR"] = 1] = "ERROR";
  LogLevel2[LogLevel2["WARN"] = 2] = "WARN";
  LogLevel2[LogLevel2["INFO"] = 3] = "INFO";
  LogLevel2[LogLevel2["DEBUG"] = 4] = "DEBUG";
  LogLevel2[LogLevel2["VERBOSE"] = 5] = "VERBOSE";
  return LogLevel2;
})(LogLevel || {});
var ProxyOps = {
  // Get the target or a property of the target
  GET: "GET",
  // Call a method on the target
  CALL: "CALL",
  // Remove the strong reference to the target on the "heap", allowing it to be
  // garbage collected
  FREE: "FREE"
};
var ProxyAddresses = {
  GLOBAL: 0,
  // globalThis
  ENV: 1,
  // env
  USER_START: 2
};
function isFetcherFetch(targetName, key) {
  return (targetName === "Fetcher" || targetName === "DurableObject") && key === "fetch";
}
function isR2ObjectWriteHttpMetadata(targetName, key) {
  return (targetName === "HeadResult" || targetName === "GetResult") && key === "writeHttpMetadata";
}

// packages/miniflare/src/workers/core/devalue.ts
var import_node_assert = __toESM(require("node:assert"));
var import_node_buffer = require("node:buffer");

// node_modules/devalue/src/utils.js
var escaped = {
  "<": "\\u003C",
  ">": "\\u003E",
  "/": "\\u002F",
  "\\": "\\\\",
  "\b": "\\b",
  "\f": "\\f",
  "\n": "\\n",
  "\r": "\\r",
  "	": "\\t",
  "\0": "\\u0000",
  "\u2028": "\\u2028",
  "\u2029": "\\u2029"
};
var DevalueError = class extends Error {
  /**
   * @param {string} message
   * @param {string[]} keys
   */
  constructor(message, keys) {
    super(message);
    this.name = "DevalueError";
    this.path = keys.join("");
  }
};
function is_primitive(thing) {
  return Object(thing) !== thing;
}
var object_proto_names = Object.getOwnPropertyNames(Object.prototype).sort().join("\0");
function is_plain_object(thing) {
  const proto = Object.getPrototypeOf(thing);
  return proto === Object.prototype || proto === null || Object.getOwnPropertyNames(proto).sort().join("\0") === object_proto_names;
}
function get_type(thing) {
  return Object.prototype.toString.call(thing).slice(8, -1);
}
function stringify_string(str) {
  let result = '"';
  for (let i = 0; i < str.length; i += 1) {
    const char = str.charAt(i);
    const code = char.charCodeAt(0);
    if (char === '"') {
      result += '\\"';
    } else if (char in escaped) {
      result += escaped[char];
    } else if (code <= 31) {
      result += `\\u${code.toString(16).toUpperCase().padStart(4, "0")}`;
    } else if (code >= 55296 && code <= 57343) {
      const next = str.charCodeAt(i + 1);
      if (code <= 56319 && next >= 56320 && next <= 57343) {
        result += char + str[++i];
      } else {
        result += `\\u${code.toString(16).toUpperCase()}`;
      }
    } else {
      result += char;
    }
  }
  result += '"';
  return result;
}

// node_modules/devalue/src/constants.js
var UNDEFINED = -1;
var HOLE = -2;
var NAN = -3;
var POSITIVE_INFINITY = -4;
var NEGATIVE_INFINITY = -5;
var NEGATIVE_ZERO = -6;

// node_modules/devalue/src/parse.js
function parse(serialized, revivers2) {
  return unflatten(JSON.parse(serialized), revivers2);
}
function unflatten(parsed, revivers2) {
  if (typeof parsed === "number")
    return hydrate(parsed, true);
  if (!Array.isArray(parsed) || parsed.length === 0) {
    throw new Error("Invalid input");
  }
  const values = (
    /** @type {any[]} */
    parsed
  );
  const hydrated = Array(values.length);
  function hydrate(index, standalone = false) {
    if (index === UNDEFINED)
      return void 0;
    if (index === NAN)
      return NaN;
    if (index === POSITIVE_INFINITY)
      return Infinity;
    if (index === NEGATIVE_INFINITY)
      return -Infinity;
    if (index === NEGATIVE_ZERO)
      return -0;
    if (standalone)
      throw new Error(`Invalid input`);
    if (index in hydrated)
      return hydrated[index];
    const value = values[index];
    if (!value || typeof value !== "object") {
      hydrated[index] = value;
    } else if (Array.isArray(value)) {
      if (typeof value[0] === "string") {
        const type = value[0];
        const reviver = revivers2?.[type];
        if (reviver) {
          return hydrated[index] = reviver(hydrate(value[1]));
        }
        switch (type) {
          case "Date":
            hydrated[index] = new Date(value[1]);
            break;
          case "Set":
            const set = /* @__PURE__ */ new Set();
            hydrated[index] = set;
            for (let i = 1; i < value.length; i += 1) {
              set.add(hydrate(value[i]));
            }
            break;
          case "Map":
            const map = /* @__PURE__ */ new Map();
            hydrated[index] = map;
            for (let i = 1; i < value.length; i += 2) {
              map.set(hydrate(value[i]), hydrate(value[i + 1]));
            }
            break;
          case "RegExp":
            hydrated[index] = new RegExp(value[1], value[2]);
            break;
          case "Object":
            hydrated[index] = Object(value[1]);
            break;
          case "BigInt":
            hydrated[index] = BigInt(value[1]);
            break;
          case "null":
            const obj = /* @__PURE__ */ Object.create(null);
            hydrated[index] = obj;
            for (let i = 1; i < value.length; i += 2) {
              obj[value[i]] = hydrate(value[i + 1]);
            }
            break;
          default:
            throw new Error(`Unknown type ${type}`);
        }
      } else {
        const array = new Array(value.length);
        hydrated[index] = array;
        for (let i = 0; i < value.length; i += 1) {
          const n = value[i];
          if (n === HOLE)
            continue;
          array[i] = hydrate(n);
        }
      }
    } else {
      const object = {};
      hydrated[index] = object;
      for (const key in value) {
        const n = value[key];
        object[key] = hydrate(n);
      }
    }
    return hydrated[index];
  }
  return hydrate(0);
}

// node_modules/devalue/src/stringify.js
function stringify(value, reducers2) {
  const stringified = [];
  const indexes = /* @__PURE__ */ new Map();
  const custom = [];
  for (const key in reducers2) {
    custom.push({ key, fn: reducers2[key] });
  }
  const keys = [];
  let p = 0;
  function flatten(thing) {
    if (typeof thing === "function") {
      throw new DevalueError(`Cannot stringify a function`, keys);
    }
    if (indexes.has(thing))
      return indexes.get(thing);
    if (thing === void 0)
      return UNDEFINED;
    if (Number.isNaN(thing))
      return NAN;
    if (thing === Infinity)
      return POSITIVE_INFINITY;
    if (thing === -Infinity)
      return NEGATIVE_INFINITY;
    if (thing === 0 && 1 / thing < 0)
      return NEGATIVE_ZERO;
    const index2 = p++;
    indexes.set(thing, index2);
    for (const { key, fn } of custom) {
      const value2 = fn(thing);
      if (value2) {
        stringified[index2] = `["${key}",${flatten(value2)}]`;
        return index2;
      }
    }
    let str = "";
    if (is_primitive(thing)) {
      str = stringify_primitive(thing);
    } else {
      const type = get_type(thing);
      switch (type) {
        case "Number":
        case "String":
        case "Boolean":
          str = `["Object",${stringify_primitive(thing)}]`;
          break;
        case "BigInt":
          str = `["BigInt",${thing}]`;
          break;
        case "Date":
          str = `["Date","${thing.toISOString()}"]`;
          break;
        case "RegExp":
          const { source, flags } = thing;
          str = flags ? `["RegExp",${stringify_string(source)},"${flags}"]` : `["RegExp",${stringify_string(source)}]`;
          break;
        case "Array":
          str = "[";
          for (let i = 0; i < thing.length; i += 1) {
            if (i > 0)
              str += ",";
            if (i in thing) {
              keys.push(`[${i}]`);
              str += flatten(thing[i]);
              keys.pop();
            } else {
              str += HOLE;
            }
          }
          str += "]";
          break;
        case "Set":
          str = '["Set"';
          for (const value2 of thing) {
            str += `,${flatten(value2)}`;
          }
          str += "]";
          break;
        case "Map":
          str = '["Map"';
          for (const [key, value2] of thing) {
            keys.push(
              `.get(${is_primitive(key) ? stringify_primitive(key) : "..."})`
            );
            str += `,${flatten(key)},${flatten(value2)}`;
          }
          str += "]";
          break;
        default:
          if (!is_plain_object(thing)) {
            throw new DevalueError(
              `Cannot stringify arbitrary non-POJOs`,
              keys
            );
          }
          if (Object.getOwnPropertySymbols(thing).length > 0) {
            throw new DevalueError(
              `Cannot stringify POJOs with symbolic keys`,
              keys
            );
          }
          if (Object.getPrototypeOf(thing) === null) {
            str = '["null"';
            for (const key in thing) {
              keys.push(`.${key}`);
              str += `,${stringify_string(key)},${flatten(thing[key])}`;
              keys.pop();
            }
            str += "]";
          } else {
            str = "{";
            let started = false;
            for (const key in thing) {
              if (started)
                str += ",";
              started = true;
              keys.push(`.${key}`);
              str += `${stringify_string(key)}:${flatten(thing[key])}`;
              keys.pop();
            }
            str += "}";
          }
      }
    }
    stringified[index2] = str;
    return index2;
  }
  const index = flatten(value);
  if (index < 0)
    return `${index}`;
  return `[${stringified.join(",")}]`;
}
function stringify_primitive(thing) {
  const type = typeof thing;
  if (type === "string")
    return stringify_string(thing);
  if (thing instanceof String)
    return stringify_string(thing.toString());
  if (thing === void 0)
    return UNDEFINED.toString();
  if (thing === 0 && 1 / thing < 0)
    return NEGATIVE_ZERO.toString();
  if (type === "bigint")
    return `["BigInt","${thing}"]`;
  return String(thing);
}

// packages/miniflare/src/workers/core/devalue.ts
var ALLOWED_ARRAY_BUFFER_VIEW_CONSTRUCTORS = [
  DataView,
  Int8Array,
  Uint8Array,
  Uint8ClampedArray,
  Int16Array,
  Uint16Array,
  Int32Array,
  Uint32Array,
  Float32Array,
  Float64Array,
  BigInt64Array,
  BigUint64Array
];
var ALLOWED_ERROR_CONSTRUCTORS = [
  EvalError,
  RangeError,
  ReferenceError,
  SyntaxError,
  TypeError,
  URIError,
  Error
  // `Error` last so more specific error subclasses preferred
];
var structuredSerializableReducers = {
  ArrayBuffer(value) {
    if (value instanceof ArrayBuffer) {
      return [import_node_buffer.Buffer.from(value).toString("base64")];
    }
  },
  ArrayBufferView(value) {
    if (ArrayBuffer.isView(value)) {
      return [
        value.constructor.name,
        value.buffer,
        value.byteOffset,
        value.byteLength
      ];
    }
  },
  Error(value) {
    for (const ctor of ALLOWED_ERROR_CONSTRUCTORS) {
      if (value instanceof ctor && value.name === ctor.name) {
        return [value.name, value.message, value.stack, value.cause];
      }
    }
    if (value instanceof Error) {
      return ["Error", value.message, value.stack, value.cause];
    }
  }
};
var structuredSerializableRevivers = {
  ArrayBuffer(value) {
    (0, import_node_assert.default)(Array.isArray(value));
    const [encoded] = value;
    (0, import_node_assert.default)(typeof encoded === "string");
    const view = import_node_buffer.Buffer.from(encoded, "base64");
    return view.buffer.slice(
      view.byteOffset,
      view.byteOffset + view.byteLength
    );
  },
  ArrayBufferView(value) {
    (0, import_node_assert.default)(Array.isArray(value));
    const [name, buffer, byteOffset, byteLength] = value;
    (0, import_node_assert.default)(typeof name === "string");
    (0, import_node_assert.default)(buffer instanceof ArrayBuffer);
    (0, import_node_assert.default)(typeof byteOffset === "number");
    (0, import_node_assert.default)(typeof byteLength === "number");
    const ctor = globalThis[name];
    (0, import_node_assert.default)(ALLOWED_ARRAY_BUFFER_VIEW_CONSTRUCTORS.includes(ctor));
    let length = byteLength;
    if ("BYTES_PER_ELEMENT" in ctor)
      length /= ctor.BYTES_PER_ELEMENT;
    return new ctor(buffer, byteOffset, length);
  },
  Error(value) {
    (0, import_node_assert.default)(Array.isArray(value));
    const [name, message, stack, cause] = value;
    (0, import_node_assert.default)(typeof name === "string");
    (0, import_node_assert.default)(typeof message === "string");
    (0, import_node_assert.default)(stack === void 0 || typeof stack === "string");
    const ctor = globalThis[name];
    (0, import_node_assert.default)(ALLOWED_ERROR_CONSTRUCTORS.includes(ctor));
    const error = new ctor(message, { cause });
    error.stack = stack;
    return error;
  }
};
function createHTTPReducers(impl) {
  return {
    Headers(val) {
      if (val instanceof impl.Headers)
        return Object.fromEntries(val);
    },
    Request(val) {
      if (val instanceof impl.Request) {
        return [val.method, val.url, val.headers, val.cf, val.body];
      }
    },
    Response(val) {
      if (val instanceof impl.Response) {
        return [val.status, val.statusText, val.headers, val.cf, val.body];
      }
    }
  };
}
function createHTTPRevivers(impl) {
  return {
    Headers(value) {
      (0, import_node_assert.default)(typeof value === "object" && value !== null);
      return new impl.Headers(value);
    },
    Request(value) {
      (0, import_node_assert.default)(Array.isArray(value));
      const [method, url, headers, cf, body] = value;
      (0, import_node_assert.default)(typeof method === "string");
      (0, import_node_assert.default)(typeof url === "string");
      (0, import_node_assert.default)(headers instanceof impl.Headers);
      (0, import_node_assert.default)(body === null || impl.isReadableStream(body));
      return new impl.Request(url, {
        method,
        headers,
        cf,
        // @ts-expect-error `duplex` is not required by `workerd` yet
        duplex: body === null ? void 0 : "half",
        body
      });
    },
    Response(value) {
      (0, import_node_assert.default)(Array.isArray(value));
      const [status, statusText, headers, cf, body] = value;
      (0, import_node_assert.default)(typeof status === "number");
      (0, import_node_assert.default)(typeof statusText === "string");
      (0, import_node_assert.default)(headers instanceof impl.Headers);
      (0, import_node_assert.default)(body === null || impl.isReadableStream(body));
      return new impl.Response(body, {
        status,
        statusText,
        headers,
        cf
      });
    }
  };
}
function stringifyWithStreams(impl, value, reducers2, allowUnbufferedStream) {
  let unbufferedStream;
  const bufferPromises = [];
  const streamReducers = {
    ReadableStream(value2) {
      if (impl.isReadableStream(value2)) {
        if (allowUnbufferedStream && unbufferedStream === void 0) {
          unbufferedStream = value2;
        } else {
          bufferPromises.push(impl.bufferReadableStream(value2));
        }
        return true;
      }
    },
    Blob(value2) {
      if (value2 instanceof impl.Blob) {
        bufferPromises.push(value2.arrayBuffer());
        return true;
      }
    },
    ...reducers2
  };
  const stringifiedValue = stringify(value, streamReducers);
  if (bufferPromises.length === 0) {
    return { value: stringifiedValue, unbufferedStream };
  }
  return Promise.all(bufferPromises).then((streamBuffers) => {
    streamReducers.ReadableStream = function(value2) {
      if (impl.isReadableStream(value2)) {
        if (value2 === unbufferedStream) {
          return true;
        } else {
          return streamBuffers.shift();
        }
      }
    };
    streamReducers.Blob = function(value2) {
      if (value2 instanceof impl.Blob) {
        const array = [streamBuffers.shift(), value2.type];
        if (value2 instanceof impl.File) {
          array.push(value2.name, value2.lastModified);
        }
        return array;
      }
    };
    const stringifiedValue2 = stringify(value, streamReducers);
    return { value: stringifiedValue2, unbufferedStream };
  });
}
function parseWithReadableStreams(impl, stringified, revivers2) {
  const streamRevivers = {
    ReadableStream(value) {
      if (value === true) {
        (0, import_node_assert.default)(stringified.unbufferedStream !== void 0);
        return stringified.unbufferedStream;
      }
      (0, import_node_assert.default)(value instanceof ArrayBuffer);
      return impl.unbufferReadableStream(value);
    },
    Blob(value) {
      (0, import_node_assert.default)(Array.isArray(value));
      if (value.length === 2) {
        const [buffer, type] = value;
        (0, import_node_assert.default)(buffer instanceof ArrayBuffer);
        (0, import_node_assert.default)(typeof type === "string");
        const opts = {};
        if (type !== "")
          opts.type = type;
        return new impl.Blob([buffer], opts);
      } else {
        (0, import_node_assert.default)(value.length === 4);
        const [buffer, type, name, lastModified] = value;
        (0, import_node_assert.default)(buffer instanceof ArrayBuffer);
        (0, import_node_assert.default)(typeof type === "string");
        (0, import_node_assert.default)(typeof name === "string");
        (0, import_node_assert.default)(typeof lastModified === "number");
        const opts = { lastModified };
        if (type !== "")
          opts.type = type;
        return new impl.File([buffer], name, opts);
      }
    },
    ...revivers2
  };
  return parse(stringified.value, streamRevivers);
}

// packages/miniflare/src/workers/core/routing.ts
function matchRoutes(routes, url) {
  for (const route of routes) {
    if (route.protocol && route.protocol !== url.protocol)
      continue;
    if (route.allowHostnamePrefix) {
      if (!url.hostname.endsWith(route.hostname))
        continue;
    } else {
      if (url.hostname !== route.hostname)
        continue;
    }
    const path14 = url.pathname + url.search;
    if (route.allowPathSuffix) {
      if (!path14.startsWith(route.path))
        continue;
    } else {
      if (path14 !== route.path)
        continue;
    }
    return route.target;
  }
  return null;
}

// packages/miniflare/src/shared/log.ts
var cwd = process.cwd();
var cwdNodeModules = import_path2.default.join(cwd, "node_modules");
var LEVEL_PREFIX = {
  [0 /* NONE */]: "",
  [1 /* ERROR */]: "err",
  [2 /* WARN */]: "wrn",
  [3 /* INFO */]: "inf",
  [4 /* DEBUG */]: "dbg",
  [5 /* VERBOSE */]: "vrb"
};
var LEVEL_COLOUR = {
  [0 /* NONE */]: import_colors2.reset,
  [1 /* ERROR */]: import_colors2.red,
  [2 /* WARN */]: import_colors2.yellow,
  [3 /* INFO */]: import_colors2.green,
  [4 /* DEBUG */]: import_colors2.grey,
  [5 /* VERBOSE */]: (input) => (0, import_colors2.dim)((0, import_colors2.grey)(input))
};
function prefixError(prefix, e) {
  if (e.stack) {
    return new Proxy(e, {
      get(target, propertyKey, receiver) {
        const value = Reflect.get(target, propertyKey, receiver);
        return propertyKey === "stack" ? `${prefix}: ${value}` : value;
      }
    });
  }
  return e;
}
function dimInternalStackLine(line) {
  if (line.startsWith("    at") && (!line.includes(cwd) || line.includes(cwdNodeModules))) {
    return (0, import_colors2.dim)(line);
  }
  return line;
}
var Log = class {
  constructor(level = 3 /* INFO */, opts = {}) {
    this.level = level;
    const prefix = opts.prefix ?? "mf";
    const suffix = opts.suffix ?? "";
    this.#prefix = prefix ? prefix + ":" : "";
    this.#suffix = suffix ? ":" + suffix : "";
  }
  #prefix;
  #suffix;
  log(message) {
    console.log(message);
  }
  logWithLevel(level, message) {
    if (level <= this.level) {
      const prefix = `[${this.#prefix}${LEVEL_PREFIX[level]}${this.#suffix}]`;
      this.log(LEVEL_COLOUR[level](`${prefix} ${message}`));
    }
  }
  error(message) {
    if (this.level < 1 /* ERROR */) {
      throw message;
    } else if (message.stack) {
      const lines = message.stack.split("\n").map(dimInternalStackLine);
      this.logWithLevel(1 /* ERROR */, lines.join("\n"));
    } else {
      this.logWithLevel(1 /* ERROR */, message.toString());
    }
    if (message.cause) {
      this.error(prefixError("Cause", message.cause));
    }
  }
  warn(message) {
    this.logWithLevel(2 /* WARN */, message);
  }
  info(message) {
    this.logWithLevel(3 /* INFO */, message);
  }
  debug(message) {
    this.logWithLevel(4 /* DEBUG */, message);
  }
  verbose(message) {
    this.logWithLevel(5 /* VERBOSE */, message);
  }
};
var NoOpLog = class extends Log {
  constructor() {
    super(0 /* NONE */);
  }
  log() {
  }
  error(message) {
    throw message;
  }
};
var ResponseInfoSchema = import_zod.z.object({
  status: import_zod.z.number(),
  statusText: import_zod.z.string(),
  method: import_zod.z.string(),
  url: import_zod.z.string(),
  time: import_zod.z.number()
});
async function formatResponse(info) {
  const url = new URL(info.url);
  const statusText = info.statusText.trim() || import_http2.default.STATUS_CODES[info.status];
  const lines = [
    `${(0, import_colors2.bold)(info.method)} ${url.pathname} `,
    colourFromHTTPStatus(info.status)(`${(0, import_colors2.bold)(info.status)} ${statusText} `),
    (0, import_colors2.grey)(`(${info.time}ms)`)
  ];
  return (0, import_colors2.reset)(lines.join(""));
}
function colourFromHTTPStatus(status) {
  if (200 <= status && status < 300)
    return import_colors2.green;
  if (400 <= status && status < 500)
    return import_colors2.yellow;
  if (500 <= status)
    return import_colors2.red;
  return import_colors2.blue;
}

// packages/miniflare/src/shared/matcher.ts
var import_glob_to_regexp = __toESM(require("glob-to-regexp"));
function globsToRegExps(globs = []) {
  const include = [];
  const exclude = [];
  const opts = { globstar: true, flags: "g" };
  for (const glob of globs) {
    if (glob.startsWith("!")) {
      exclude.push(new RegExp((0, import_glob_to_regexp.default)(glob.slice(1), opts), ""));
    } else {
      include.push(new RegExp((0, import_glob_to_regexp.default)(glob, opts), ""));
    }
  }
  return { include, exclude };
}
function testRegExps(matcher, value) {
  for (const exclude of matcher.exclude)
    if (exclude.test(value))
      return false;
  for (const include of matcher.include)
    if (include.test(value))
      return true;
  return false;
}
function serialiseRegExp(regExp) {
  const str = regExp.toString();
  return str.substring(str.indexOf("/") + 1, str.lastIndexOf("/"));
}
function serialiseRegExps(matcher) {
  return {
    include: matcher.include.map(serialiseRegExp),
    exclude: matcher.exclude.map(serialiseRegExp)
  };
}
function deserialiseRegExps(matcher) {
  return {
    include: matcher.include.map((regExp) => new RegExp(regExp)),
    exclude: matcher.exclude.map((regExp) => new RegExp(regExp))
  };
}

// packages/miniflare/src/shared/streams.ts
var import_web = require("stream/web");
function prefixStream(prefix, stream) {
  const identity2 = new import_web.TransformStream();
  const writer = identity2.writable.getWriter();
  void writer.write(prefix).then(() => {
    writer.releaseLock();
    return stream.pipeTo(identity2.writable);
  }).catch((error) => {
    return writer.abort(error);
  });
  return identity2.readable;
}
async function readPrefix(stream, prefixLength) {
  const chunks = [];
  let chunksLength = 0;
  for await (const chunk of stream.values({ preventCancel: true })) {
    chunks.push(chunk);
    chunksLength += chunk.byteLength;
    if (chunksLength >= prefixLength)
      break;
  }
  if (chunksLength < prefixLength) {
    throw new RangeError(
      `Expected ${prefixLength} byte prefix, but received ${chunksLength} byte stream`
    );
  }
  const atLeastPrefix = Buffer.concat(chunks, chunksLength);
  const prefix = atLeastPrefix.subarray(0, prefixLength);
  let rest = stream;
  if (chunksLength > prefixLength) {
    rest = prefixStream(atLeastPrefix.subarray(prefixLength), stream);
  }
  return [prefix, rest];
}

// packages/miniflare/src/shared/sync.ts
var import_assert2 = __toESM(require("assert"));
var DeferredPromise = class extends Promise {
  resolve;
  reject;
  constructor(executor = () => {
  }) {
    let promiseResolve;
    let promiseReject;
    super((resolve, reject) => {
      promiseResolve = resolve;
      promiseReject = reject;
      return executor(resolve, reject);
    });
    this.resolve = promiseResolve;
    this.reject = promiseReject;
  }
};
var Mutex = class {
  locked = false;
  resolveQueue = [];
  drainQueue = [];
  lock() {
    if (!this.locked) {
      this.locked = true;
      return;
    }
    return new Promise((resolve) => this.resolveQueue.push(resolve));
  }
  unlock() {
    (0, import_assert2.default)(this.locked);
    if (this.resolveQueue.length > 0) {
      this.resolveQueue.shift()?.();
    } else {
      this.locked = false;
      let resolve;
      while ((resolve = this.drainQueue.shift()) !== void 0)
        resolve();
    }
  }
  get hasWaiting() {
    return this.resolveQueue.length > 0;
  }
  async runWith(closure) {
    const acquireAwaitable = this.lock();
    if (acquireAwaitable instanceof Promise)
      await acquireAwaitable;
    try {
      const awaitable = closure();
      if (awaitable instanceof Promise)
        return await awaitable;
      return awaitable;
    } finally {
      this.unlock();
    }
  }
  async drained() {
    if (this.resolveQueue.length === 0)
      return;
    return new Promise((resolve) => this.drainQueue.push(resolve));
  }
};
var WaitGroup = class {
  counter = 0;
  resolveQueue = [];
  add() {
    this.counter++;
  }
  done() {
    (0, import_assert2.default)(this.counter > 0);
    this.counter--;
    if (this.counter === 0) {
      let resolve;
      while ((resolve = this.resolveQueue.shift()) !== void 0)
        resolve();
    }
  }
  wait() {
    if (this.counter === 0)
      return Promise.resolve();
    return new Promise((resolve) => this.resolveQueue.push(resolve));
  }
};

// packages/miniflare/src/shared/types.ts
var import_zod2 = require("zod");
function zAwaitable(type) {
  return type.or(import_zod2.z.promise(type));
}
var LiteralSchema = import_zod2.z.union([
  import_zod2.z.string(),
  import_zod2.z.number(),
  import_zod2.z.boolean(),
  import_zod2.z.null()
]);
var JsonSchema = import_zod2.z.lazy(
  () => import_zod2.z.union([LiteralSchema, import_zod2.z.array(JsonSchema), import_zod2.z.record(JsonSchema)])
);
function maybeApply(f, maybeValue) {
  return maybeValue === void 0 ? void 0 : f(maybeValue);
}
var HEX_REGEXP = /^[0-9a-f]*$/i;
var BASE64_REGEXP = /^[0-9a-z+/=]*$/i;
var HexDataSchema = import_zod2.z.string().regex(HEX_REGEXP).transform((hex) => Buffer.from(hex, "hex"));
var Base64DataSchema = import_zod2.z.string().regex(BASE64_REGEXP).transform((base64) => Buffer.from(base64, "base64"));

// packages/miniflare/src/http/request.ts
var import_undici2 = require("undici");
var kCf = Symbol("kCf");
var Request = class extends import_undici2.Request {
  // We should be able to use a private `#cf` property here instead of a symbol
  // here, but we need to set this on a clone, which would otherwise lead to a
  // "Cannot write private member to an object whose class did not declare it"
  // error.
  [kCf];
  constructor(input, init) {
    super(input, init);
    this[kCf] = init?.cf;
    if (input instanceof Request)
      this[kCf] ??= input.cf;
  }
  get cf() {
    return this[kCf];
  }
  // JSDoc comment so retained when bundling types with api-extractor
  /** @ts-expect-error `clone` is actually defined as a method internally */
  clone() {
    const request = super.clone();
    Object.setPrototypeOf(request, Request.prototype);
    request[kCf] = this[kCf];
    return request;
  }
};

// packages/miniflare/src/http/response.ts
var import_undici3 = require("undici");
var kWebSocket = Symbol("kWebSocket");
var Response = class extends import_undici3.Response {
  // We should be able to use a private `#webSocket` property here instead of a
  // symbol here, but `undici` calls `this.status` in its constructor, which
  // causes a "Cannot read private member from an object whose class did not
  // declare it" error.
  [kWebSocket];
  // Override BaseResponse's static methods for building Responses to return
  // our type instead. Ideally, we don't want to use `Object.setPrototypeOf`.
  // Unfortunately, `error()` and `redirect()` set the internal header guard
  // to "immutable".
  static error() {
    const response = import_undici3.Response.error();
    Object.setPrototypeOf(response, Response.prototype);
    return response;
  }
  static redirect(url, status) {
    const response = import_undici3.Response.redirect(url, status);
    Object.setPrototypeOf(response, Response.prototype);
    return response;
  }
  static json(data, init) {
    const body = JSON.stringify(data);
    const response = new Response(body, init);
    response.headers.set("Content-Type", "application/json");
    return response;
  }
  constructor(body, init) {
    if (init?.webSocket) {
      if (init.status !== 101) {
        throw new RangeError(
          "Responses with a WebSocket must have status code 101."
        );
      }
      init = { ...init, status: 200 };
    }
    super(body, init);
    this[kWebSocket] = init?.webSocket ?? null;
  }
  // JSDoc comment so retained when bundling types with api-extractor
  /** @ts-expect-error `status` is actually defined as a getter internally */
  get status() {
    return this[kWebSocket] ? 101 : super.status;
  }
  get webSocket() {
    return this[kWebSocket];
  }
  // JSDoc comment so retained when bundling types with api-extractor
  /** @ts-expect-error `clone` is actually defined as a method internally */
  clone() {
    if (this[kWebSocket]) {
      throw new TypeError("Cannot clone a response to a WebSocket handshake.");
    }
    const response = super.clone();
    Object.setPrototypeOf(response, Response.prototype);
    return response;
  }
};

// packages/miniflare/src/http/websocket.ts
var import_assert3 = __toESM(require("assert"));
var import_events = require("events");
var import_ws = __toESM(require("ws"));
var MessageEvent = class extends Event {
  data;
  constructor(type, init) {
    super(type);
    this.data = init.data;
  }
};
var CloseEvent = class extends Event {
  code;
  reason;
  wasClean;
  constructor(type, init) {
    super(type);
    this.code = init?.code ?? 1005;
    this.reason = init?.reason ?? "";
    this.wasClean = init?.wasClean ?? false;
  }
};
var ErrorEvent = class extends Event {
  error;
  constructor(type, init) {
    super(type);
    this.error = init?.error ?? null;
  }
};
var kPair = Symbol("kPair");
var kAccepted = Symbol("kAccepted");
var kCoupled = Symbol("kCoupled");
var kClosedOutgoing = Symbol("kClosedOutgoing");
var kClosedIncoming = Symbol("kClosedIncoming");
var kSend = Symbol("kSend");
var kClose = Symbol("kClose");
var kError = Symbol("kError");
var _dispatchQueue, _a, _b, _c, _d, _e, _queuingDispatchToPair, queuingDispatchToPair_fn;
var _WebSocket = class extends TypedEventTarget {
  constructor() {
    super(...arguments);
    __privateAdd(this, _queuingDispatchToPair);
    __privateAdd(this, _dispatchQueue, []);
    __publicField(this, _a);
    __publicField(this, _b, false);
    __publicField(this, _c, false);
    __publicField(this, _d, false);
    __publicField(this, _e, false);
  }
  get readyState() {
    if (this[kClosedOutgoing] && this[kClosedIncoming]) {
      return _WebSocket.READY_STATE_CLOSED;
    } else if (this[kClosedOutgoing] || this[kClosedIncoming]) {
      return _WebSocket.READY_STATE_CLOSING;
    }
    return _WebSocket.READY_STATE_OPEN;
  }
  accept() {
    if (this[kCoupled]) {
      throw new TypeError(
        "Can't accept() WebSocket that was already used in a response."
      );
    }
    if (this[kAccepted])
      return;
    this[kAccepted] = true;
    if (__privateGet(this, _dispatchQueue) !== void 0) {
      for (const event of __privateGet(this, _dispatchQueue))
        this.dispatchEvent(event);
      __privateSet(this, _dispatchQueue, void 0);
    }
  }
  send(message) {
    if (!this[kAccepted]) {
      throw new TypeError(
        "You must call accept() on this WebSocket before sending messages."
      );
    }
    this[kSend](message);
  }
  [(_a = kPair, _b = kAccepted, _c = kCoupled, _d = kClosedOutgoing, _e = kClosedIncoming, kSend)](message) {
    if (this[kClosedOutgoing]) {
      throw new TypeError("Can't call WebSocket send() after close().");
    }
    const event = new MessageEvent("message", { data: message });
    void __privateMethod(this, _queuingDispatchToPair, queuingDispatchToPair_fn).call(this, event);
  }
  close(code, reason) {
    if (code) {
      const validCode = code >= 1e3 && code < 5e3 && code !== 1004 && code !== 1005 && code !== 1006 && code !== 1015;
      if (!validCode)
        throw new TypeError("Invalid WebSocket close code.");
    }
    if (reason !== void 0 && code === void 0) {
      throw new TypeError(
        "If you specify a WebSocket close reason, you must also specify a code."
      );
    }
    if (!this[kAccepted]) {
      throw new TypeError(
        "You must call accept() on this WebSocket before sending messages."
      );
    }
    this[kClose](code, reason);
  }
  [kClose](code, reason) {
    if (this[kClosedOutgoing])
      throw new TypeError("WebSocket already closed");
    this[kClosedOutgoing] = true;
    this[kPair][kClosedIncoming] = true;
    const event = new CloseEvent("close", { code, reason });
    void __privateMethod(this, _queuingDispatchToPair, queuingDispatchToPair_fn).call(this, event);
  }
  [kError](error) {
    const event = new ErrorEvent("error", { error });
    void __privateMethod(this, _queuingDispatchToPair, queuingDispatchToPair_fn).call(this, event);
  }
};
var WebSocket = _WebSocket;
_dispatchQueue = new WeakMap();
_queuingDispatchToPair = new WeakSet();
queuingDispatchToPair_fn = async function(event) {
  const pair = this[kPair];
  if (pair[kAccepted]) {
    pair.dispatchEvent(event);
  } else {
    (0, import_assert3.default)(__privateGet(pair, _dispatchQueue) !== void 0);
    __privateGet(pair, _dispatchQueue).push(event);
  }
};
// The Workers runtime prefixes these constants with `READY_STATE_`, unlike
// those in the spec: https://websockets.spec.whatwg.org/#interface-definition
__publicField(WebSocket, "READY_STATE_CONNECTING", 0);
__publicField(WebSocket, "READY_STATE_OPEN", 1);
__publicField(WebSocket, "READY_STATE_CLOSING", 2);
__publicField(WebSocket, "READY_STATE_CLOSED", 3);
var WebSocketPair = function() {
  if (!(this instanceof WebSocketPair)) {
    throw new TypeError(
      "Failed to construct 'WebSocketPair': Please use the 'new' operator, this object constructor cannot be called as a function."
    );
  }
  this[0] = new WebSocket();
  this[1] = new WebSocket();
  this[0][kPair] = this[1];
  this[1][kPair] = this[0];
};
async function coupleWebSocket(ws, pair) {
  if (pair[kCoupled]) {
    throw new TypeError(
      "Can't return WebSocket that was already used in a response."
    );
  }
  if (pair[kAccepted]) {
    throw new TypeError(
      "Can't return WebSocket in a Response after calling accept()."
    );
  }
  ws.on("message", (message, isBinary) => {
    if (!pair[kClosedOutgoing]) {
      pair[kSend](isBinary ? viewToBuffer(message) : message.toString());
    }
  });
  ws.on("close", (code, reason) => {
    if (!pair[kClosedOutgoing]) {
      pair[kClose](code, reason.toString());
    }
  });
  ws.on("error", (error) => {
    pair[kError](error);
  });
  pair.addEventListener("message", (e) => {
    ws.send(e.data);
  });
  pair.addEventListener("close", (e) => {
    if (e.code === 1005) {
      ws.close();
    } else if (e.code === 1006) {
      ws.terminate();
    } else {
      ws.close(e.code, e.reason);
    }
  });
  if (ws.readyState === import_ws.default.CONNECTING) {
    await (0, import_events.once)(ws, "open");
  } else if (ws.readyState >= import_ws.default.CLOSING) {
    throw new TypeError("Incoming WebSocket connection already closed.");
  }
  pair.accept();
  pair[kCoupled] = true;
}

// packages/miniflare/src/http/fetch.ts
var allowUnauthorizedAgent = new import_undici4.Agent({
  connect: { rejectUnauthorized: false }
});
var ignored = ["transfer-encoding", "connection", "keep-alive", "expect"];
function headersFromIncomingRequest(req) {
  const entries = Object.entries(req.headers).filter(
    (pair) => {
      const [name, value] = pair;
      return !ignored.includes(name) && value !== void 0;
    }
  );
  return new import_undici4.Headers(Object.fromEntries(entries));
}
async function fetch2(input, init) {
  const requestInit = init;
  const request = new Request(input, requestInit);
  if (request.method === "GET" && request.headers.get("upgrade") === "websocket") {
    const url = new URL(request.url);
    if (url.protocol !== "http:" && url.protocol !== "https:") {
      throw new TypeError(
        `Fetch API cannot load: ${url.toString()}.
Make sure you're using http(s):// URLs for WebSocket requests via fetch.`
      );
    }
    url.protocol = url.protocol.replace("http", "ws");
    const headers = {};
    let protocols;
    for (const [key, value] of request.headers.entries()) {
      if (key.toLowerCase() === "sec-websocket-protocol") {
        protocols = value.split(",").map((protocol) => protocol.trim());
      } else {
        headers[key] = value;
      }
    }
    const rejectUnauthorized = requestInit?.dispatcher === allowUnauthorizedAgent ? { rejectUnauthorized: false } : {};
    const ws = new import_ws2.default(url, protocols, {
      followRedirects: request.redirect === "follow",
      headers,
      ...rejectUnauthorized
    });
    const headersPromise = new DeferredPromise();
    ws.once("upgrade", (req) => {
      headersPromise.resolve(headersFromIncomingRequest(req));
    });
    const [worker, client] = Object.values(new WebSocketPair());
    await coupleWebSocket(ws, client);
    return new Response(null, {
      status: 101,
      webSocket: worker,
      headers: await headersPromise
    });
  }
  const response = await (0, import_undici4.fetch)(request, {
    dispatcher: requestInit?.dispatcher
  });
  return new Response(response.body, response);
}

// packages/miniflare/src/http/server.ts
var import_promises8 = __toESM(require("fs/promises"));

// packages/miniflare/src/plugins/cache/index.ts
var import_zod7 = require("zod");

// packages/miniflare/src/plugins/shared/index.ts
var import_zod5 = require("zod");

// packages/miniflare/src/plugins/shared/gateway.ts
var import_path5 = __toESM(require("path"));
var import_url = require("url");
var import_zod3 = require("zod");

// packages/miniflare/src/storage/blob/store.ts
var import_assert5 = __toESM(require("assert"));
var import_crypto2 = __toESM(require("crypto"));
var import_promises2 = __toESM(require("fs/promises"));
var import_path3 = __toESM(require("path"));
var import_consumers = require("stream/consumers");

// packages/miniflare/src/storage/blob/streams.ts
var import_assert4 = __toESM(require("assert"));
var import_crypto = require("crypto");
var import_fs = require("fs");
var import_web2 = require("stream/web");
var DEFAULT_CHUNK_SIZE = 1024;
var MULTIPART_BOUNDARY_PREFIX = "miniflare-boundary-";
var encoder = new TextEncoder();
function assertRange({ start, end }) {
  (0, import_assert4.default)(0 <= start && start <= end, `Invalid range: [${start},${end}]`);
}
function unwrapBYOBRequest(controller) {
  const byobRequest = controller.byobRequest;
  (0, import_assert4.default)(byobRequest !== void 0);
  (0, import_assert4.default)(byobRequest.view !== null);
  return byobRequest;
}
function createArrayRangeSource(array) {
  return {
    async readInto(view, position, length) {
      (0, import_assert4.default)(length <= view.byteLength);
      const subarray = array.subarray(position, position + length);
      view.set(subarray);
      return subarray.length;
    }
  };
}
async function createFileRangeSource(filePath) {
  const handle = await import_fs.promises.open(filePath, "r");
  return {
    async readInto(view, position, length) {
      (0, import_assert4.default)(length <= view.byteLength);
      const { bytesRead } = await handle.read(view, 0, length, position);
      return bytesRead;
    },
    close() {
      return handle.close();
    }
  };
}
function createReadableStream(source, range) {
  if (range !== void 0)
    assertRange(range);
  let position = range?.start ?? 0;
  return new import_web2.ReadableStream({
    type: "bytes",
    autoAllocateChunkSize: DEFAULT_CHUNK_SIZE,
    async pull(controller) {
      const byobRequest = unwrapBYOBRequest(controller);
      const v = byobRequest.view;
      let length = v.byteLength;
      if (range !== void 0) {
        length = Math.min(length, range.end - position + 1);
      }
      const bytesRead = await source.readInto(v, position, length);
      if (bytesRead === 0) {
        await source.close?.();
        controller.close();
      } else {
        position += bytesRead;
      }
      byobRequest.respond(bytesRead);
    },
    cancel() {
      return source.close?.();
    }
  });
}
function createMultipartReadableStream(source, ranges, opts) {
  for (const range of ranges)
    assertRange(range);
  const boundary = MULTIPART_BOUNDARY_PREFIX + import_crypto.webcrypto.randomUUID();
  const multipartContentType = `multipart/byteranges; boundary=${boundary}`;
  let state;
  let position = 0;
  ranges = ranges.slice();
  function nextState() {
    if (state === void 0 || "range" in state) {
      let toWrite;
      const nextRange = ranges.shift();
      if (nextRange === void 0) {
        toWrite = `--${boundary}--`;
      } else {
        toWrite = `--${boundary}\r
`;
        if (opts.contentType !== void 0) {
          toWrite += `Content-Type: ${opts.contentType}\r
`;
        }
        const start = nextRange.start;
        const end = Math.min(nextRange.end, opts.contentLength - 1);
        toWrite += `Content-Range: bytes ${start}-${end}/${opts.contentLength}\r
\r
`;
      }
      if (state !== void 0)
        toWrite = `\r
${toWrite}`;
      position = 0;
      state = { array: encoder.encode(toWrite), nextRange };
    } else {
      if (state.nextRange === void 0) {
        return true;
      } else {
        position = state.nextRange.start;
        state = { range: state.nextRange };
      }
    }
    return false;
  }
  (0, import_assert4.default)(!nextState());
  const body = new import_web2.ReadableStream({
    type: "bytes",
    autoAllocateChunkSize: DEFAULT_CHUNK_SIZE,
    async pull(controller) {
      (0, import_assert4.default)(state !== void 0);
      (0, import_assert4.default)(this.pull !== void 0);
      const byobRequest = unwrapBYOBRequest(controller);
      const v = byobRequest.view;
      if ("range" in state) {
        const range = state.range;
        const length = Math.min(v.byteLength, range.end - position + 1);
        const bytesRead = await source.readInto(v, position, length);
        if (bytesRead === 0) {
          (0, import_assert4.default)(!nextState());
          return this.pull(controller);
        } else {
          position += bytesRead;
          byobRequest.respond(bytesRead);
        }
      } else {
        const array = state.array;
        const length = Math.min(v.byteLength, array.byteLength - position);
        if (length === 0) {
          if (nextState()) {
            await source.close?.();
            controller.close();
            byobRequest.respond(0);
          } else {
            return this.pull(controller);
          }
        } else {
          v.set(array.subarray(position, position + length));
          position += length;
          byobRequest.respond(length);
        }
      }
    },
    cancel() {
      return source.close?.();
    }
  });
  return { multipartContentType, body };
}
function createArrayReadableStream(array, range) {
  const source = createArrayRangeSource(array);
  return createReadableStream(source, range);
}
async function createFileReadableStream(filePath, range) {
  const source = await createFileRangeSource(filePath);
  return createReadableStream(source, range);
}
function createMultipartArrayReadableStream(array, ranges, opts) {
  const source = createArrayRangeSource(array);
  return createMultipartReadableStream(source, ranges, opts);
}
async function createMultipartFileReadableStream(filePath, ranges, opts) {
  const source = await createFileRangeSource(filePath);
  return createMultipartReadableStream(source, ranges, opts);
}
async function createFileWritableStream(filePath, exclusive = false) {
  const handle = await import_fs.promises.open(filePath, exclusive ? "wx" : "w");
  return new import_web2.WritableStream({
    write(chunk) {
      const promise = handle.write(chunk, 0, chunk.length);
      return promise;
    },
    close() {
      return handle.close();
    },
    abort() {
      return handle.close();
    }
  });
}

// packages/miniflare/src/storage/blob/store.ts
var MODE_READ_ONLY = 292;
function generateBlobId() {
  const idBuffer = Buffer.alloc(32 + 8);
  import_crypto2.default.randomFillSync(idBuffer, 0, 32);
  idBuffer.writeBigUint64BE(process.hrtime.bigint(), 32);
  return idBuffer.toString("hex");
}
var MemoryBlobStore = class {
  #blobs = /* @__PURE__ */ new Map();
  async get(id, ranges, opts) {
    const blob = this.#blobs.get(id);
    if (blob === void 0)
      return null;
    if (Array.isArray(ranges)) {
      (0, import_assert5.default)(opts !== void 0);
      return createMultipartArrayReadableStream(blob, ranges, opts);
    } else {
      return createArrayReadableStream(blob, ranges);
    }
  }
  async put(stream) {
    const id = generateBlobId();
    const buffer = await (0, import_consumers.arrayBuffer)(stream);
    const blob = new Uint8Array(buffer);
    (0, import_assert5.default)(!this.#blobs.has(id));
    this.#blobs.set(id, blob);
    return id;
  }
  async delete(id) {
    this.#blobs.delete(id);
  }
};
var FileBlobStore = class {
  #root;
  constructor(root) {
    this.#root = import_path3.default.resolve(root);
  }
  #idFilePath(id) {
    const filePath = import_path3.default.join(this.#root, id);
    return filePath.startsWith(this.#root) ? filePath : null;
  }
  async get(id, ranges, opts) {
    const filePath = this.#idFilePath(id);
    if (filePath === null)
      return null;
    try {
      if (Array.isArray(ranges)) {
        (0, import_assert5.default)(opts !== void 0);
        return await createMultipartFileReadableStream(filePath, ranges, opts);
      } else {
        return await createFileReadableStream(filePath, ranges);
      }
    } catch (e) {
      if (typeof e === "object" && e !== null && "code" in e && e.code === "ENOENT") {
        return null;
      }
      throw e;
    }
  }
  async put(stream) {
    const id = generateBlobId();
    const filePath = this.#idFilePath(id);
    (0, import_assert5.default)(filePath !== null);
    await import_promises2.default.mkdir(import_path3.default.dirname(filePath), { recursive: true });
    const writable = await createFileWritableStream(
      filePath,
      true
      /* excl. */
    );
    await import_promises2.default.chmod(filePath, MODE_READ_ONLY);
    await stream.pipeTo(writable);
    return id;
  }
  async delete(id) {
    const filePath = this.#idFilePath(id);
    try {
      if (filePath !== null)
        await import_promises2.default.unlink(filePath);
    } catch (e) {
      if (typeof e === "object" && e !== null && "code" in e && e.code === "ENOENT") {
        return;
      }
      throw e;
    }
  }
};

// packages/miniflare/src/storage/keyvalue.ts
var import_assert6 = __toESM(require("assert"));
var SQL_SCHEMA = `
CREATE TABLE IF NOT EXISTS _mf_entries (
  key TEXT PRIMARY KEY,
  blob_id TEXT NOT NULL,
  expiration INTEGER,
  metadata TEXT
);
CREATE INDEX IF NOT EXISTS _mf_entries_expiration_idx ON _mf_entries(expiration);
`;
function sqlStmts(db) {
  const stmtGetBlobIdByKey = db.prepare(
    "SELECT blob_id FROM _mf_entries WHERE key = :key"
  );
  const stmtPut = db.prepare(
    `INSERT OR REPLACE INTO _mf_entries (key, blob_id, expiration, metadata)
    VALUES (:key, :blob_id, :expiration, :metadata)`
  );
  return {
    getByKey: db.prepare(
      "SELECT key, blob_id, expiration, metadata FROM _mf_entries WHERE key = :key"
    ),
    put: db.transaction((newEntry) => {
      const key = newEntry.key;
      const entry = stmtGetBlobIdByKey.get({ key });
      stmtPut.run(newEntry);
      return entry?.blob_id;
    }),
    deleteByKey: db.prepare("DELETE FROM _mf_entries WHERE key = :key RETURNING blob_id, expiration"),
    deleteExpired: db.prepare(
      // `expiration` may be `NULL`, but `NULL < ...` should be falsy
      "DELETE FROM _mf_entries WHERE expiration < :now RETURNING blob_id"
    ),
    list: db.prepare(
      `SELECT key, expiration, metadata FROM _mf_entries
        WHERE key LIKE :escaped_prefix || '%' ESCAPE '\\'
        AND key > :start_after
        AND (expiration IS NULL OR expiration >= :now)
        ORDER BY key LIMIT :limit`
    )
  };
}
function escapePrefix(prefix) {
  return prefix.replace(/[\\_%]/g, "\\$&");
}
function rowEntry(entry) {
  return {
    key: entry.key,
    expiration: entry.expiration ?? void 0,
    metadata: entry.metadata === null ? void 0 : JSON.parse(entry.metadata)
  };
}
var KeyValueStorage = class {
  constructor(storage, timers = defaultTimers) {
    this.storage = storage;
    this.timers = timers;
    storage.db.pragma("case_sensitive_like = TRUE");
    storage.db.exec(SQL_SCHEMA);
    this.#stmts = sqlStmts(storage.db);
  }
  #stmts;
  #hasExpired(entry) {
    return entry.expiration !== null && entry.expiration <= this.timers.now();
  }
  #backgroundDelete(blobId) {
    queueMicrotask(() => this.storage.blob.delete(blobId).catch(() => {
    }));
  }
  async get(key, optsFactory) {
    const row = this.#stmts.getByKey.get({ key });
    if (row === void 0)
      return null;
    if (this.#hasExpired(row)) {
      this.#stmts.deleteByKey.run({ key });
      this.#backgroundDelete(row.blob_id);
      return null;
    }
    const entry = rowEntry(row);
    const opts = entry.metadata && optsFactory?.(entry.metadata);
    if (opts?.ranges === void 0 || opts.ranges.length <= 1) {
      const value = await this.storage.blob.get(row.blob_id, opts?.ranges?.[0]);
      if (value === null)
        return null;
      return { ...entry, value };
    } else {
      const value = await this.storage.blob.get(row.blob_id, opts.ranges, opts);
      if (value === null)
        return null;
      return { ...entry, value };
    }
  }
  async put(entry) {
    import_assert6.default.notStrictEqual(entry.key, "");
    const blobId = await this.storage.blob.put(entry.value);
    const maybeOldBlobId = this.#stmts.put({
      key: entry.key,
      blob_id: blobId,
      expiration: entry.expiration ?? null,
      metadata: entry.metadata === void 0 ? null : JSON.stringify(await entry.metadata)
    });
    if (maybeOldBlobId !== void 0)
      this.#backgroundDelete(maybeOldBlobId);
  }
  async delete(key) {
    const row = this.#stmts.deleteByKey.get({ key });
    if (row === void 0)
      return false;
    this.#backgroundDelete(row.blob_id);
    return !this.#hasExpired(row);
  }
  async list(opts) {
    const now = this.timers.now();
    const rows = this.#stmts.list.all({
      now,
      escaped_prefix: escapePrefix(opts.prefix ?? ""),
      // Note the "" default here prohibits empty string keys. The consumers
      // of this class are KV and Cache. KV validates keys are non-empty.
      // Cache keys are usually URLs, but can be customised with `cf.cacheKey`.
      // If this is empty, we can just not cache the response, since that
      // satisfies the Cache API contract.
      start_after: opts.cursor === void 0 ? "" : base64Decode(opts.cursor),
      // Increase the queried limit by 1, if we return this many results, we
      // know there are more rows. We'll truncate to the original limit before
      // returning results.
      limit: opts.limit + 1
    });
    const expiredRows = this.#stmts.deleteExpired.all({ now });
    for (const row of expiredRows)
      this.#backgroundDelete(row.blob_id);
    const hasMoreRows = rows.length === opts.limit + 1;
    rows.splice(opts.limit, 1);
    const keys = rows.map((row) => rowEntry(row));
    const nextCursor = hasMoreRows ? base64Encode(rows[opts.limit - 1].key) : void 0;
    return { keys, cursor: nextCursor };
  }
};

// packages/miniflare/src/storage/sql.ts
function escapeLike(prefix) {
  return prefix.replace(/[\\_%]/g, "\\$&");
}

// packages/miniflare/src/storage/storage.ts
var import_fs2 = __toESM(require("fs"));
var import_path4 = __toESM(require("path"));
var import_better_sqlite3 = __toESM(require("better-sqlite3"));
function createMemoryStorage() {
  const db = new import_better_sqlite3.default(":memory:");
  const blob = new MemoryBlobStore();
  return { db, blob };
}
function createFileStorage(root) {
  root = import_path4.default.resolve(root);
  import_fs2.default.mkdirSync(root, { recursive: true });
  const db = new import_better_sqlite3.default(import_path4.default.join(root, "db.sqlite"));
  db.pragma("journal_mode = WAL");
  const blob = new FileBlobStore(import_path4.default.join(root, "blobs"));
  return { db, blob };
}

// packages/miniflare/src/plugins/shared/gateway.ts
var PersistenceSchema = import_zod3.z.boolean().or(import_zod3.z.string()).optional();
var CloudflareFetchSchema = (
  // TODO(soon): figure out a way to do optional parameters with z.function()
  import_zod3.z.custom()
);
var DEFAULT_PERSIST_ROOT = ".mf";
var PARAM_FILE_UNSANITISE = "unsanitise";
function maybeParseURL(url) {
  if (typeof url !== "string" || import_path5.default.isAbsolute(url))
    return;
  try {
    return new URL(url);
  } catch {
  }
}
var GatewayFactory = class {
  constructor(log, timers, dispatchFetch, pluginName, gatewayClass) {
    this.log = log;
    this.timers = timers;
    this.dispatchFetch = dispatchFetch;
    this.pluginName = pluginName;
    this.gatewayClass = gatewayClass;
  }
  #memoryStorages = /* @__PURE__ */ new Map();
  #gateways = /* @__PURE__ */ new Map();
  #getMemoryStorage(namespace) {
    let storage = this.#memoryStorages.get(namespace);
    if (storage !== void 0)
      return storage;
    this.#memoryStorages.set(namespace, storage = createMemoryStorage());
    return storage;
  }
  getStorage(namespace, persist) {
    if (persist === void 0 || persist === false) {
      return this.#getMemoryStorage(namespace);
    }
    const sanitisedNamespace = sanitisePath(namespace);
    const url = maybeParseURL(persist);
    if (url !== void 0) {
      if (url.protocol === "memory:") {
        return this.#getMemoryStorage(namespace);
      }
      if (url.protocol === "file:") {
        const root2 = import_path5.default.join((0, import_url.fileURLToPath)(url), sanitisedNamespace);
        return createFileStorage(root2);
      }
      throw new MiniflareCoreError(
        "ERR_PERSIST_UNSUPPORTED",
        `Unsupported "${url.protocol}" persistence protocol for storage: ${url.href}`
      );
    }
    const root = persist === true ? import_path5.default.join(DEFAULT_PERSIST_ROOT, this.pluginName, sanitisedNamespace) : import_path5.default.join(persist, sanitisedNamespace);
    return createFileStorage(root);
  }
  get(namespace, persist) {
    const cached = this.#gateways.get(namespace);
    if (cached !== void 0 && cached[0] === persist)
      return cached[1];
    const storage = this.getStorage(namespace, persist);
    const gateway = new this.gatewayClass(
      this.log,
      storage,
      this.timers,
      namespace,
      this.dispatchFetch
    );
    this.#gateways.set(namespace, [persist, gateway]);
    return gateway;
  }
};

// packages/miniflare/src/plugins/shared/constants.ts
var SOCKET_ENTRY = "entry";
var SERVICE_LOOPBACK = "loopback";
var HEADER_PERSIST = "MF-Persist";
var HEADER_CF_BLOB = "MF-CF-Blob";
var BINDING_TEXT_PLUGIN = "MINIFLARE_PLUGIN";
var BINDING_TEXT_NAMESPACE = "MINIFLARE_NAMESPACE";
var BINDING_TEXT_PERSIST = "MINIFLARE_PERSIST";
var WORKER_BINDING_SERVICE_LOOPBACK = {
  name: CoreBindings.SERVICE_LOOPBACK,
  service: { name: SERVICE_LOOPBACK }
};
var SCRIPT_PLUGIN_NAMESPACE_PERSIST_COMPAT_DATE = "2022-09-01";
var SCRIPT_PLUGIN_NAMESPACE_PERSIST = `addEventListener("fetch", (event) => {
  let request = event.request;
  const url = new URL(request.url);
  url.pathname = \`/\${${BINDING_TEXT_PLUGIN}}/\${${BINDING_TEXT_NAMESPACE}}\${url.pathname}\`;
  if (globalThis.${BINDING_TEXT_PERSIST} !== undefined) {
    request = new Request(request);
    request.headers.set("${HEADER_PERSIST}", ${BINDING_TEXT_PERSIST});
  }
  event.respondWith(${CoreBindings.SERVICE_LOOPBACK}.fetch(url, request));
});`;
function encodePersist(persist) {
  if (persist === void 0)
    return [];
  else
    return [{ name: BINDING_TEXT_PERSIST, text: JSON.stringify(persist) }];
}
function decodePersist(headers) {
  const header = headers.get(HEADER_PERSIST);
  return header === null ? void 0 : PersistenceSchema.parse(JSON.parse(header));
}
function pluginNamespacePersistWorker(plugin, namespace, persist) {
  return {
    serviceWorkerScript: SCRIPT_PLUGIN_NAMESPACE_PERSIST,
    compatibilityDate: SCRIPT_PLUGIN_NAMESPACE_PERSIST_COMPAT_DATE,
    bindings: [
      ...encodePersist(persist),
      { name: BINDING_TEXT_PLUGIN, text: plugin },
      { name: BINDING_TEXT_NAMESPACE, text: namespace },
      WORKER_BINDING_SERVICE_LOOPBACK
    ]
  };
}
var CfHeader = /* @__PURE__ */ ((CfHeader2) => {
  CfHeader2["Error"] = "cf-r2-error";
  CfHeader2["Request"] = "cf-r2-request";
  CfHeader2["MetadataSize"] = "cf-r2-metadata-size";
  CfHeader2["Blob"] = "cf-blob";
  CfHeader2["CacheNamespace"] = "cf-cache-namespace";
  CfHeader2["CacheStatus"] = "cf-cache-status";
  return CfHeader2;
})(CfHeader || {});

// packages/miniflare/src/plugins/shared/range.ts
var rangePrefixRegexp = /^ *bytes *=/i;
var rangeRegexp = /^ *(?<start>\d+)? *- *(?<end>\d+)? *$/;
function _parseRanges(rangeHeader, length) {
  const prefixMatch = rangePrefixRegexp.exec(rangeHeader);
  if (prefixMatch === null)
    return;
  rangeHeader = rangeHeader.substring(prefixMatch[0].length);
  if (rangeHeader.trimStart() === "")
    return [];
  const ranges = rangeHeader.split(",");
  const result = [];
  for (const range of ranges) {
    const match = rangeRegexp.exec(range);
    if (match === null)
      return;
    const { start, end } = match.groups;
    if (start !== void 0 && end !== void 0) {
      const rangeStart = parseInt(start);
      let rangeEnd = parseInt(end);
      if (rangeStart > rangeEnd)
        return;
      if (rangeStart >= length)
        return;
      if (rangeEnd >= length)
        rangeEnd = length - 1;
      result.push({ start: rangeStart, end: rangeEnd });
    } else if (start !== void 0 && end === void 0) {
      const rangeStart = parseInt(start);
      if (rangeStart >= length)
        return;
      result.push({ start: rangeStart, end: length - 1 });
    } else if (start === void 0 && end !== void 0) {
      const suffix = parseInt(end);
      if (suffix >= length)
        return [];
      if (suffix === 0)
        continue;
      result.push({ start: length - suffix, end: length - 1 });
    } else {
      return;
    }
  }
  return result;
}

// packages/miniflare/src/plugins/shared/registry.ts
var import_crypto3 = __toESM(require("crypto"));
var import_promises3 = __toESM(require("fs/promises"));
var import_path6 = __toESM(require("path"));
var import_url2 = require("url");
var import_zod4 = require("zod");
var IgnoreSourcePredicateSchema = import_zod4.z.function().args(import_zod4.z.string()).returns(import_zod4.z.boolean());
function maybeParseURL2(url) {
  if (import_path6.default.isAbsolute(url))
    return;
  try {
    return new URL(url);
  } catch {
  }
}
var _map;
var _SourceMapRegistry = class {
  constructor(log, loopbackPort, ignoreSourcePredicate) {
    this.log = log;
    this.loopbackPort = loopbackPort;
    this.ignoreSourcePredicate = ignoreSourcePredicate;
    __privateAdd(this, _map, /* @__PURE__ */ new Map());
  }
  register(script, scriptPath) {
    const mappingURLIndex = script.lastIndexOf("//# sourceMappingURL=");
    if (mappingURLIndex === -1)
      return script;
    const scriptURL = (0, import_url2.pathToFileURL)(scriptPath);
    const sourceSegment = script.substring(0, mappingURLIndex);
    const mappingURLSegment = script.substring(mappingURLIndex).replace(/^\/\/# sourceMappingURL=(.+)/, (substring, mappingURL) => {
      if (maybeParseURL2(mappingURL) !== void 0)
        return substring;
      const resolvedMappingURL = new URL(mappingURL, scriptURL);
      const resolvedMappingPath = (0, import_url2.fileURLToPath)(resolvedMappingURL);
      const id = import_crypto3.default.randomUUID();
      __privateGet(this, _map).set(id, resolvedMappingPath);
      mappingURL = `http://localhost:${this.loopbackPort}${_SourceMapRegistry.PATHNAME_PREFIX}${id}`;
      this.log.verbose(
        `Registered source map ${JSON.stringify(
          resolvedMappingPath
        )} at ${mappingURL}`
      );
      return `//# sourceMappingURL=${mappingURL}`;
    });
    return sourceSegment + mappingURLSegment;
  }
  async get(url) {
    const id = url.pathname.substring(_SourceMapRegistry.PATHNAME_PREFIX.length);
    const sourceMapPath = __privateGet(this, _map).get(id);
    if (sourceMapPath === void 0)
      return;
    let contents;
    try {
      contents = await import_promises3.default.readFile(sourceMapPath, "utf8");
    } catch (e) {
      this.log.warn(
        `Error reading source map ${JSON.stringify(sourceMapPath)}: ${e}`
      );
      return;
    }
    let map;
    try {
      map = JSON.parse(contents);
    } catch (e) {
      this.log.warn(
        `Error parsing source map ${JSON.stringify(sourceMapPath)}: ${e}`
      );
      return;
    }
    const sourceMapDir = import_path6.default.dirname(sourceMapPath);
    map.sourceRoot = map.sourceRoot === void 0 ? sourceMapDir : import_path6.default.resolve(sourceMapDir, map.sourceRoot);
    if (this.ignoreSourcePredicate !== void 0 && map.sources !== void 0) {
      const ignoreList = [];
      for (let i = 0; i < map.sources.length; i++) {
        if (this.ignoreSourcePredicate(map.sources[i]))
          ignoreList.push(i);
      }
      map.x_google_ignoreList = ignoreList;
    }
    return Response.json(map, {
      // This source map will be served from the loopback server to DevTools,
      // which will likely be on a different origin.
      headers: { "Access-Control-Allow-Origin": "*" }
    });
  }
};
var SourceMapRegistry = _SourceMapRegistry;
_map = new WeakMap();
__publicField(SourceMapRegistry, "PATHNAME_PREFIX", "/core/source-map/");

// packages/miniflare/src/plugins/shared/router.ts
var Router = class {
  constructor(log, gatewayFactory) {
    this.log = log;
    this.gatewayFactory = gatewayFactory;
    this.routes = new.target.prototype.routes;
  }
  // Routes added by @METHOD decorators
  routes;
  async route(req, url) {
    url ??= new URL(req.url);
    const methodRoutes = this.routes?.get(req.method);
    if (methodRoutes !== void 0) {
      for (const [path14, key] of methodRoutes) {
        const match = path14.exec(url.pathname);
        if (match !== null) {
          return this[key](req, match.groups, url);
        }
      }
    }
  }
};
function pathToRegexp(path14) {
  if (!path14.endsWith("/"))
    path14 += "/?";
  path14 = path14.replace(/\//g, "\\/");
  path14 = path14.replace(/:(\w+)/g, "(?<$1>[^\\/]+)");
  return new RegExp(`^${path14}$`);
}
var createRouteDecorator = (method) => (path14) => (prototype, key) => {
  const route = [pathToRegexp(path14), key];
  const routes = prototype.routes ??= /* @__PURE__ */ new Map();
  const methodRoutes = routes.get(method);
  if (methodRoutes)
    methodRoutes.push(route);
  else
    routes.set(method, [route]);
};
var GET = createRouteDecorator("GET");
var HEAD = createRouteDecorator("HEAD");
var POST = createRouteDecorator("POST");
var PUT = createRouteDecorator("PUT");
var DELETE = createRouteDecorator("DELETE");
var PURGE = createRouteDecorator("PURGE");
var PATCH = createRouteDecorator("PATCH");

// packages/miniflare/src/plugins/shared/routing.ts
var import_url3 = require("url");
var RouterError = class extends MiniflareError {
};
function routeSpecificity(url) {
  const hostParts = url.host.split(".");
  let hostScore = hostParts.length;
  if (hostParts[0] === "*")
    hostScore -= 2;
  const pathParts = url.pathname.split("/");
  let pathScore = pathParts.length;
  if (pathParts[pathParts.length - 1] === "*")
    pathScore -= 2;
  return hostScore * 26 + pathScore;
}
function parseRoutes(allRoutes) {
  const routes = [];
  for (const [target, targetRoutes] of allRoutes) {
    for (const route of targetRoutes) {
      const hasProtocol = /^[a-z0-9+\-.]+:\/\//i.test(route);
      let urlInput = route;
      if (!hasProtocol)
        urlInput = `https://${urlInput}`;
      const url = new import_url3.URL(urlInput);
      const specificity = routeSpecificity(url);
      const protocol = hasProtocol ? url.protocol : void 0;
      const internationalisedAllowHostnamePrefix = url.hostname.startsWith("xn--*");
      const allowHostnamePrefix = url.hostname.startsWith("*") || internationalisedAllowHostnamePrefix;
      const anyHostname = url.hostname === "*";
      if (allowHostnamePrefix && !anyHostname) {
        let hostname = url.hostname;
        if (internationalisedAllowHostnamePrefix) {
          hostname = (0, import_url3.domainToUnicode)(hostname);
        }
        url.hostname = hostname.substring(1);
      }
      const allowPathSuffix = url.pathname.endsWith("*");
      if (allowPathSuffix) {
        url.pathname = url.pathname.substring(0, url.pathname.length - 1);
      }
      if (url.search) {
        throw new RouterError(
          "ERR_QUERY_STRING",
          `Route "${route}" for "${target}" contains a query string. This is not allowed.`
        );
      }
      if (url.toString().includes("*") && !anyHostname) {
        throw new RouterError(
          "ERR_INFIX_WILDCARD",
          `Route "${route}" for "${target}" contains an infix wildcard. This is not allowed.`
        );
      }
      routes.push({
        target,
        route,
        specificity,
        protocol,
        allowHostnamePrefix,
        hostname: anyHostname ? "" : url.hostname,
        path: url.pathname,
        allowPathSuffix
      });
    }
  }
  routes.sort((a, b) => {
    if (a.specificity === b.specificity) {
      return b.route.length - a.route.length;
    } else {
      return b.specificity - a.specificity;
    }
  });
  return routes;
}

// packages/miniflare/src/plugins/shared/index.ts
var QueueConsumerOptionsSchema = import_zod5.z.object({
  // https://developers.cloudflare.com/queues/platform/configuration/#consumer
  // https://developers.cloudflare.com/queues/platform/limits/
  maxBatchSize: import_zod5.z.number().min(0).max(100).optional(),
  maxBatchTimeout: import_zod5.z.number().min(0).max(30).optional(),
  // seconds
  maxRetires: import_zod5.z.number().min(0).max(100).optional(),
  deadLetterQueue: import_zod5.z.ostring()
});
var kProxyNodeBinding = Symbol("kProxyNodeBinding");
function namespaceKeys(namespaces) {
  if (Array.isArray(namespaces)) {
    return namespaces;
  } else if (namespaces !== void 0) {
    return Object.keys(namespaces);
  } else {
    return [];
  }
}
function namespaceEntries(namespaces) {
  if (Array.isArray(namespaces)) {
    return namespaces.map((bindingName) => [bindingName, bindingName]);
  } else if (namespaces !== void 0) {
    return Object.entries(namespaces);
  } else {
    return [];
  }
}

// packages/miniflare/src/plugins/cache/constants.ts
var HEADER_CACHE_WARN_USAGE = "MF-Cache-Warn";

// packages/miniflare/src/plugins/cache/gateway.ts
var import_assert9 = __toESM(require("assert"));
var import_crypto4 = __toESM(require("crypto"));
var import_http6 = __toESM(require("http"));
var import_web4 = require("stream/web");
var import_http_cache_semantics = __toESM(require("http-cache-semantics"));

// packages/miniflare/src/plugins/kv/index.ts
var import_zod6 = require("zod");

// packages/miniflare/src/plugins/kv/constants.ts
var KV_PLUGIN_NAME = "kv";
var MIN_CACHE_TTL = 60;
var MAX_LIST_KEYS = 1e3;
var MAX_KEY_SIZE = 512;
var MAX_VALUE_SIZE = 25 * 1024 * 1024;
var MAX_METADATA_SIZE = 1024;
var PARAM_URL_ENCODED = "urlencoded";
var PARAM_CACHE_TTL = "cache_ttl";
var PARAM_EXPIRATION = "expiration";
var PARAM_EXPIRATION_TTL = "expiration_ttl";
var PARAM_LIST_LIMIT = "key_count_limit";
var PARAM_LIST_PREFIX = "prefix";
var PARAM_LIST_CURSOR = "cursor";
var HEADER_EXPIRATION = "CF-Expiration";
var HEADER_METADATA = "CF-KV-Metadata";
var HEADER_SITES = "MF-Sites";

// packages/miniflare/src/plugins/kv/gateway.ts
var import_web3 = require("stream/web");
var KVError = class extends HttpError {
};
function validateKey(key) {
  if (key === "") {
    throw new KVError(400, "Key names must not be empty");
  }
  if (key === "." || key === "..") {
    throw new KVError(
      400,
      `Illegal key name "${key}". Please use a different name.`
    );
  }
  validateKeyLength(key);
}
function validateKeyLength(key) {
  const keyLength = Buffer.byteLength(key);
  if (keyLength > MAX_KEY_SIZE) {
    throw new KVError(
      414,
      `UTF-8 encoded length of ${keyLength} exceeds key length limit of ${MAX_KEY_SIZE}.`
    );
  }
}
function normaliseInt(value) {
  switch (typeof value) {
    case "string":
      return parseInt(value);
    case "number":
      return Math.round(value);
  }
}
function createMaxValueSizeError(length) {
  return new KVError(
    413,
    `Value length of ${length} exceeds limit of ${MAX_VALUE_SIZE}.`
  );
}
var MaxLengthStream = class extends import_web3.TransformStream {
  constructor(maxLength, errorFactory) {
    let length = 0;
    super({
      transform(chunk, controller) {
        length += chunk.byteLength;
        if (length <= maxLength)
          controller.enqueue(chunk);
      },
      flush(controller) {
        if (length > maxLength)
          controller.error(errorFactory(length));
      }
    });
  }
};
function validateGetOptions(key, options) {
  validateKey(key);
  const cacheTtl = options?.cacheTtl;
  if (cacheTtl !== void 0 && (isNaN(cacheTtl) || cacheTtl < MIN_CACHE_TTL)) {
    throw new KVError(
      400,
      `Invalid ${PARAM_CACHE_TTL} of ${cacheTtl}. Cache TTL must be at least ${MIN_CACHE_TTL}.`
    );
  }
}
function validateListOptions(options) {
  const limit = options.limit;
  if (limit !== void 0) {
    if (isNaN(limit) || limit < 1) {
      throw new KVError(
        400,
        `Invalid ${PARAM_LIST_LIMIT} of ${limit}. Please specify an integer greater than 0.`
      );
    }
    if (limit > MAX_LIST_KEYS) {
      throw new KVError(
        400,
        `Invalid ${PARAM_LIST_LIMIT} of ${limit}. Please specify an integer less than ${MAX_LIST_KEYS}.`
      );
    }
  }
  const prefix = options.prefix;
  if (prefix !== void 0)
    validateKeyLength(prefix);
}
var KVGateway = class {
  constructor(log, storage, timers) {
    this.log = log;
    this.timers = timers;
    this.storage = new KeyValueStorage(storage, timers);
  }
  storage;
  async get(key, options) {
    validateGetOptions(key, options);
    const entry = await this.storage.get(key);
    if (entry === null)
      return;
    return {
      value: entry.value,
      expiration: maybeApply(millisToSeconds, entry.expiration),
      metadata: entry.metadata
    };
  }
  async put(key, value, options = {}) {
    validateKey(key);
    const now = millisToSeconds(this.timers.now());
    let expiration = normaliseInt(options.expiration);
    const expirationTtl = normaliseInt(options.expirationTtl);
    if (expirationTtl !== void 0) {
      if (isNaN(expirationTtl) || expirationTtl <= 0) {
        throw new KVError(
          400,
          `Invalid ${PARAM_EXPIRATION_TTL} of ${options.expirationTtl}. Please specify integer greater than 0.`
        );
      }
      if (expirationTtl < MIN_CACHE_TTL) {
        throw new KVError(
          400,
          `Invalid ${PARAM_EXPIRATION_TTL} of ${options.expirationTtl}. Expiration TTL must be at least ${MIN_CACHE_TTL}.`
        );
      }
      expiration = now + expirationTtl;
    } else if (expiration !== void 0) {
      if (isNaN(expiration) || expiration <= now) {
        throw new KVError(
          400,
          `Invalid ${PARAM_EXPIRATION} of ${options.expiration}. Please specify integer greater than the current number of seconds since the UNIX epoch.`
        );
      }
      if (expiration < now + MIN_CACHE_TTL) {
        throw new KVError(
          400,
          `Invalid ${PARAM_EXPIRATION} of ${options.expiration}. Expiration times must be at least ${MIN_CACHE_TTL} seconds in the future.`
        );
      }
    }
    if (options.metadata !== void 0) {
      const metadataJSON = JSON.stringify(options.metadata);
      const metadataLength = Buffer.byteLength(metadataJSON);
      if (metadataLength > MAX_METADATA_SIZE) {
        throw new KVError(
          413,
          `Metadata length of ${metadataLength} exceeds limit of ${MAX_METADATA_SIZE}.`
        );
      }
    }
    const valueLengthHint = options.valueLengthHint;
    if (valueLengthHint !== void 0 && valueLengthHint > MAX_VALUE_SIZE) {
      throw createMaxValueSizeError(valueLengthHint);
    } else {
      value = value.pipeThrough(
        new MaxLengthStream(MAX_VALUE_SIZE, createMaxValueSizeError)
      );
    }
    return this.storage.put({
      key,
      value,
      expiration: maybeApply(secondsToMillis, expiration),
      metadata: options.metadata
    });
  }
  async delete(key) {
    validateKey(key);
    await this.storage.delete(key);
  }
  async list(options = {}) {
    validateListOptions(options);
    const { limit = MAX_LIST_KEYS, prefix, cursor } = options;
    const res = await this.storage.list({ limit, prefix, cursor });
    const keys = res.keys.map((key) => ({
      name: key.key,
      expiration: maybeApply(millisToSeconds, key.expiration),
      // workerd expects metadata to be a JSON-serialised string
      metadata: maybeApply(JSON.stringify, key.metadata)
    }));
    if (res.cursor === void 0) {
      return { keys, list_complete: true, cursor: void 0 };
    } else {
      return { keys, list_complete: false, cursor: res.cursor };
    }
  }
};

// packages/miniflare/src/plugins/kv/router.ts
var import_assert8 = __toESM(require("assert"));

// packages/miniflare/src/plugins/kv/sites.ts
var import_assert7 = __toESM(require("assert"));
var import_promises4 = __toESM(require("fs/promises"));
var import_path7 = __toESM(require("path"));
async function* listKeysInDirectoryInner(rootPath, currentPath) {
  const fileEntries = await import_promises4.default.readdir(currentPath, { withFileTypes: true });
  for (const fileEntry of fileEntries) {
    const filePath = import_path7.default.posix.join(currentPath, fileEntry.name);
    if (fileEntry.isDirectory()) {
      yield* listKeysInDirectoryInner(rootPath, filePath);
    } else {
      yield filePath.substring(rootPath.length + 1);
    }
  }
}
function listKeysInDirectory(rootPath) {
  rootPath = import_path7.default.resolve(rootPath);
  return listKeysInDirectoryInner(rootPath, rootPath);
}
var sitesRegExpsCache = /* @__PURE__ */ new WeakMap();
function serialiseSiteRegExps(exps) {
  return {
    include: exps.include && serialiseRegExps(exps.include),
    exclude: exps.exclude && serialiseRegExps(exps.exclude)
  };
}
function deserialiseSiteRegExps(exps) {
  return {
    include: exps.include && deserialiseRegExps(exps.include),
    exclude: exps.exclude && deserialiseRegExps(exps.exclude)
  };
}
function testSiteRegExps(regExps, key) {
  return (
    // Either include globs undefined, or name matches them
    (regExps.include === void 0 || testRegExps(regExps.include, key)) && // Either exclude globs undefined, or name doesn't match them
    (regExps.exclude === void 0 || !testRegExps(regExps.exclude, key))
  );
}
var SITES_NO_CACHE_PREFIX = "$__MINIFLARE_SITES__$/";
function encodeSitesKey(key) {
  return SITES_NO_CACHE_PREFIX + encodeURIComponent(key);
}
function decodeSitesKey(key) {
  return key.startsWith(SITES_NO_CACHE_PREFIX) ? decodeURIComponent(key.substring(SITES_NO_CACHE_PREFIX.length)) : key;
}
function isSitesRequest(request) {
  const url = new URL(request.url);
  return url.pathname.startsWith(`/${SITES_NO_CACHE_PREFIX}`);
}
var SERVICE_NAMESPACE_SITE = `${KV_PLUGIN_NAME}:site`;
var BINDING_KV_NAMESPACE_SITE = "__STATIC_CONTENT";
var BINDING_JSON_SITE_MANIFEST = "__STATIC_CONTENT_MANIFEST";
var BINDING_TEXT_SITE_FILTER = "MINIFLARE_SITE_FILTER";
var SCRIPT_SITE = `
function handleRequest(request) {
  // Only permit reads
  if (request.method !== "GET") {
    const message = \`Cannot \${request.method.toLowerCase()}() with read-only Workers Sites namespace\`;
    return new Response(message, { status: 405, statusText: message });
  }
  
  const url = new URL(request.url);
  url.pathname = \`/${KV_PLUGIN_NAME}/${BINDING_KV_NAMESPACE_SITE}/\${url.pathname}\`;
  
  request = new Request(url, request);
  request.headers.set("${HEADER_PERSIST}", ${BINDING_TEXT_PERSIST});
  // Add magic header to indicate namespace should be ignored, and persist
  // should be used as the root without any additional namespace
  request.headers.set("${HEADER_SITES}", ${BINDING_TEXT_SITE_FILTER});
  return ${CoreBindings.SERVICE_LOOPBACK}.fetch(request);
}

addEventListener("fetch", (event) => event.respondWith(handleRequest(event.request)));
`;
async function buildStaticContentManifest(sitePath, siteRegExps) {
  const staticContentManifest = {};
  for await (const key of listKeysInDirectory(sitePath)) {
    if (testSiteRegExps(siteRegExps, key)) {
      staticContentManifest[key] = encodeSitesKey(key);
    }
  }
  return staticContentManifest;
}
async function getSitesBindings(options) {
  const siteRegExps = {
    include: options.siteInclude && globsToRegExps(options.siteInclude),
    exclude: options.siteExclude && globsToRegExps(options.siteExclude)
  };
  sitesRegExpsCache.set(options, siteRegExps);
  const __STATIC_CONTENT_MANIFEST = await buildStaticContentManifest(
    options.sitePath,
    siteRegExps
  );
  return [
    {
      name: BINDING_KV_NAMESPACE_SITE,
      kvNamespace: { name: SERVICE_NAMESPACE_SITE }
    },
    {
      name: BINDING_JSON_SITE_MANIFEST,
      json: JSON.stringify(__STATIC_CONTENT_MANIFEST)
    }
  ];
}
async function getSitesNodeBindings(options) {
  const siteRegExps = sitesRegExpsCache.get(options);
  (0, import_assert7.default)(siteRegExps !== void 0);
  const __STATIC_CONTENT_MANIFEST = await buildStaticContentManifest(
    options.sitePath,
    siteRegExps
  );
  return {
    [BINDING_KV_NAMESPACE_SITE]: kProxyNodeBinding,
    [BINDING_JSON_SITE_MANIFEST]: __STATIC_CONTENT_MANIFEST
  };
}
function maybeGetSitesManifestModule(bindings) {
  for (const binding of bindings) {
    if (binding.name === BINDING_JSON_SITE_MANIFEST) {
      (0, import_assert7.default)("json" in binding && binding.json !== void 0);
      return { name: BINDING_JSON_SITE_MANIFEST, text: binding.json };
    }
  }
}
function getSitesService(options) {
  const siteRegExps = sitesRegExpsCache.get(options);
  (0, import_assert7.default)(siteRegExps !== void 0);
  const serialisedSiteRegExps = serialiseSiteRegExps(siteRegExps);
  const persist = import_path7.default.resolve(options.sitePath);
  return {
    name: SERVICE_NAMESPACE_SITE,
    worker: {
      serviceWorkerScript: SCRIPT_SITE,
      compatibilityDate: "2022-09-01",
      bindings: [
        WORKER_BINDING_SERVICE_LOOPBACK,
        {
          name: BINDING_TEXT_PERSIST,
          text: JSON.stringify(persist)
        },
        {
          name: BINDING_TEXT_SITE_FILTER,
          text: JSON.stringify(serialisedSiteRegExps)
        }
      ]
    }
  };
}
async function sitesGatewayGet(persist, serialisedSiteRegExps, key, opts) {
  (0, import_assert7.default)(typeof persist === "string");
  const siteRegExps = deserialiseSiteRegExps(JSON.parse(serialisedSiteRegExps));
  validateGetOptions(key, opts);
  key = decodeSitesKey(key);
  if (!testSiteRegExps(siteRegExps, key))
    return;
  const filePath = import_path7.default.join(persist, key);
  if (!filePath.startsWith(persist))
    return;
  try {
    return { value: await createFileReadableStream(filePath) };
  } catch (e) {
    if (typeof e === "object" && e !== null && "code" in e && e.code === "ENOENT") {
      return;
    }
    throw e;
  }
}
async function sitesGatewayList(persist, serialisedSiteRegExps, opts = {}) {
  (0, import_assert7.default)(typeof persist === "string");
  const siteRegExps = deserialiseSiteRegExps(JSON.parse(serialisedSiteRegExps));
  validateListOptions(opts);
  const { limit = MAX_LIST_KEYS, prefix, cursor } = opts;
  let keys = [];
  for await (let name of listKeysInDirectory(persist)) {
    if (!testSiteRegExps(siteRegExps, name))
      continue;
    name = encodeSitesKey(name);
    if (prefix === void 0 || name.startsWith(prefix))
      keys.push({ name });
  }
  keys.sort((a, b) => lexicographicCompare(a.name, b.name));
  const startAfter = cursor === void 0 ? "" : base64Decode(cursor);
  let startIndex = 0;
  if (startAfter !== "") {
    startIndex = keys.findIndex(({ name }) => name === startAfter);
    if (startIndex === -1)
      startIndex = keys.length;
    startIndex++;
  }
  const endIndex = startIndex + limit;
  const nextCursor = endIndex < keys.length ? base64Encode(keys[endIndex - 1].name) : void 0;
  keys = keys.slice(startIndex, endIndex);
  if (nextCursor === void 0) {
    return { keys, list_complete: true, cursor: void 0 };
  } else {
    return { keys, list_complete: false, cursor: nextCursor };
  }
}

// packages/miniflare/src/plugins/kv/router.ts
function decodeKey({ key }, query) {
  if (query.get(PARAM_URL_ENCODED)?.toLowerCase() !== "true")
    return key;
  try {
    return decodeURIComponent(key);
  } catch (e) {
    if (e instanceof URIError) {
      throw new KVError(400, "Could not URL-decode key name");
    } else {
      throw e;
    }
  }
}
var KVRouter = class extends Router {
  get = async (req, params, url) => {
    const persist = decodePersist(req.headers);
    const namespace = decodeURIComponent(params.namespace);
    const key = decodeKey(params, url.searchParams);
    const cacheTtlParam = url.searchParams.get(PARAM_CACHE_TTL);
    const options = {
      cacheTtl: cacheTtlParam === null ? void 0 : parseInt(cacheTtlParam)
    };
    let value;
    const siteRegExps = req.headers.get(HEADER_SITES);
    if (siteRegExps === null) {
      const gateway = this.gatewayFactory.get(namespace, persist);
      value = await gateway.get(key, options);
    } else {
      value = await sitesGatewayGet(persist, siteRegExps, key, options);
    }
    if (value === void 0)
      throw new KVError(404, "Not Found");
    const headers = new import_undici8.Headers();
    if (value.expiration !== void 0) {
      headers.set(HEADER_EXPIRATION, value.expiration.toString());
    }
    if (value.metadata !== void 0) {
      headers.set(HEADER_METADATA, JSON.stringify(value.metadata));
    }
    return new Response(value.value, { headers });
  };
  put = async (req, params, url) => {
    const persist = decodePersist(req.headers);
    const namespace = decodeURIComponent(params.namespace);
    const gateway = this.gatewayFactory.get(namespace, persist);
    const key = decodeKey(params, url.searchParams);
    const expiration = url.searchParams.get(PARAM_EXPIRATION) ?? void 0;
    const expirationTtl = url.searchParams.get(PARAM_EXPIRATION_TTL) ?? void 0;
    const metadataHeader = req.headers.get(HEADER_METADATA);
    const metadata = metadataHeader === null ? void 0 : JSON.parse(metadataHeader);
    const value = req.body;
    (0, import_assert8.default)(value !== null);
    const contentLength = parseInt(req.headers.get("Content-Length"));
    const valueLengthHint = Number.isNaN(contentLength) ? void 0 : contentLength;
    await gateway.put(key, value, {
      expiration,
      expirationTtl,
      metadata,
      valueLengthHint
    });
    return new Response();
  };
  delete = async (req, params, url) => {
    const persist = decodePersist(req.headers);
    const namespace = decodeURIComponent(params.namespace);
    const gateway = this.gatewayFactory.get(namespace, persist);
    const key = decodeKey(params, url.searchParams);
    await gateway.delete(key);
    return new Response();
  };
  list = async (req, params, url) => {
    const persist = decodePersist(req.headers);
    const namespace = decodeURIComponent(params.namespace);
    const limitParam = url.searchParams.get(PARAM_LIST_LIMIT);
    const limit = limitParam === null ? void 0 : parseInt(limitParam);
    const prefix = url.searchParams.get(PARAM_LIST_PREFIX) ?? void 0;
    const cursor = url.searchParams.get(PARAM_LIST_CURSOR) ?? void 0;
    const options = { limit, prefix, cursor };
    let result;
    const siteRegExps = req.headers.get(HEADER_SITES);
    if (siteRegExps === null) {
      const gateway = this.gatewayFactory.get(namespace, persist);
      result = await gateway.list(options);
    } else {
      result = await sitesGatewayList(persist, siteRegExps, options);
    }
    return Response.json(result);
  };
};
__decorateClass([
  GET("/:namespace/:key")
], KVRouter.prototype, "get", 2);
__decorateClass([
  PUT("/:namespace/:key")
], KVRouter.prototype, "put", 2);
__decorateClass([
  DELETE("/:namespace/:key")
], KVRouter.prototype, "delete", 2);
__decorateClass([
  GET("/:namespace/")
], KVRouter.prototype, "list", 2);

// packages/miniflare/src/plugins/kv/index.ts
var KVOptionsSchema = import_zod6.z.object({
  kvNamespaces: import_zod6.z.union([import_zod6.z.record(import_zod6.z.string()), import_zod6.z.string().array()]).optional(),
  // Workers Sites
  sitePath: import_zod6.z.string().optional(),
  siteInclude: import_zod6.z.string().array().optional(),
  siteExclude: import_zod6.z.string().array().optional()
});
var KVSharedOptionsSchema = import_zod6.z.object({
  kvPersist: PersistenceSchema
});
var SERVICE_NAMESPACE_PREFIX = `${KV_PLUGIN_NAME}:ns`;
function isWorkersSitesEnabled(options) {
  return options.sitePath !== void 0;
}
var KV_PLUGIN = {
  gateway: KVGateway,
  router: KVRouter,
  options: KVOptionsSchema,
  sharedOptions: KVSharedOptionsSchema,
  async getBindings(options) {
    const namespaces = namespaceEntries(options.kvNamespaces);
    const bindings = namespaces.map(([name, id]) => ({
      name,
      kvNamespace: { name: `${SERVICE_NAMESPACE_PREFIX}:${id}` }
    }));
    if (isWorkersSitesEnabled(options)) {
      bindings.push(...await getSitesBindings(options));
    }
    return bindings;
  },
  async getNodeBindings(options) {
    const namespaces = namespaceKeys(options.kvNamespaces);
    const bindings = Object.fromEntries(
      namespaces.map((name) => [name, kProxyNodeBinding])
    );
    if (isWorkersSitesEnabled(options)) {
      Object.assign(bindings, await getSitesNodeBindings(options));
    }
    return bindings;
  },
  getServices({ options, sharedOptions }) {
    const persist = sharedOptions.kvPersist;
    const namespaces = namespaceEntries(options.kvNamespaces);
    const services = namespaces.map(([_, id]) => ({
      name: `${SERVICE_NAMESPACE_PREFIX}:${id}`,
      worker: pluginNamespacePersistWorker(
        KV_PLUGIN_NAME,
        encodeURIComponent(id),
        persist
      )
    }));
    if (isWorkersSitesEnabled(options)) {
      services.push(getSitesService(options));
    }
    return services;
  }
};

// packages/miniflare/src/plugins/cache/errors.ts
var CacheError = class extends HttpError {
  constructor(code, message, headers = []) {
    super(code, message);
    this.headers = headers;
  }
  toResponse() {
    return new Response(null, {
      status: this.code,
      headers: this.headers
    });
  }
  context(info) {
    this.message += ` (${info})`;
    return this;
  }
};
var StorageFailure = class extends CacheError {
  constructor() {
    super(413 /* PayloadTooLarge */, "Cache storage failed");
  }
};
var PurgeFailure = class extends CacheError {
  constructor() {
    super(404 /* NotFound */, "Couldn't find asset to purge");
  }
};
var CacheMiss = class extends CacheError {
  constructor() {
    super(
      // workerd ignores this, but it's the correct status code
      504 /* CacheMiss */,
      "Asset not found in cache",
      [["cf-cache-status" /* CacheStatus */, "MISS"]]
    );
  }
};
var RangeNotSatisfiable = class extends CacheError {
  constructor(size) {
    super(416 /* RangeNotSatisfiable */, "Range not satisfiable", [
      ["Content-Range", `bytes */${size}`],
      ["cf-cache-status" /* CacheStatus */, "HIT"]
    ]);
  }
};

// packages/miniflare/src/plugins/cache/gateway.ts
function getExpiration(timers, req, res) {
  const reqHeaders = normaliseHeaders(req.headers);
  delete reqHeaders["cache-control"];
  const resHeaders = normaliseHeaders(res.headers);
  if (resHeaders["cache-control"]?.toLowerCase().includes("private=set-cookie")) {
    resHeaders["cache-control"] = resHeaders["cache-control"]?.toLowerCase().replace(/private=set-cookie;?/i, "");
    delete resHeaders["set-cookie"];
  }
  const cacheReq = {
    url: req.url,
    // If a request gets to the Cache service, it's method will be GET. See README.md for details
    method: "GET",
    headers: reqHeaders
  };
  const cacheRes = {
    status: res.status,
    headers: resHeaders
  };
  const originalNow = import_http_cache_semantics.default.prototype.now;
  import_http_cache_semantics.default.prototype.now = timers.now;
  try {
    const policy = new import_http_cache_semantics.default(cacheReq, cacheRes, { shared: true });
    return {
      // Check if the request & response is cacheable
      storable: policy.storable() && !("set-cookie" in resHeaders),
      expiration: policy.timeToLive(),
      // Cache Policy Headers is typed as [header: string]: string | string[] | undefined
      // It's safe to ignore the undefined here, which is what casting to HeadersInit does
      headers: policy.responseHeaders()
    };
  } finally {
    import_http_cache_semantics.default.prototype.now = originalNow;
  }
}
function normaliseHeaders(headers) {
  const result = {};
  for (const [key, value] of headers)
    result[key.toLowerCase()] = value;
  return result;
}
var etagRegexp = /^(W\/)?"(.+)"$/;
function parseETag(value) {
  return etagRegexp.exec(value.trim())?.[2] ?? void 0;
}
var utcDateRegexp = /^(Mon|Tue|Wed|Thu|Fri|Sat|Sun), \d\d (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d\d\d\d \d\d:\d\d:\d\d GMT$/;
function parseUTCDate(value) {
  return utcDateRegexp.test(value) ? Date.parse(value) : NaN;
}
function getMatchResponse(reqHeaders, res) {
  const reqIfNoneMatchHeader = reqHeaders.get("If-None-Match");
  const resETagHeader = res.headers.get("ETag");
  if (reqIfNoneMatchHeader !== null && resETagHeader !== null) {
    const resETag = parseETag(resETagHeader);
    if (resETag !== void 0) {
      if (reqIfNoneMatchHeader.trim() === "*") {
        return new Response(null, { status: 304, headers: res.headers });
      }
      for (const reqIfNoneMatch of reqIfNoneMatchHeader.split(",")) {
        if (resETag === parseETag(reqIfNoneMatch)) {
          return new Response(null, { status: 304, headers: res.headers });
        }
      }
    }
  }
  const reqIfModifiedSinceHeader = reqHeaders.get("If-Modified-Since");
  const resLastModifiedHeader = res.headers.get("Last-Modified");
  if (reqIfModifiedSinceHeader !== null && resLastModifiedHeader !== null) {
    const reqIfModifiedSince = parseUTCDate(reqIfModifiedSinceHeader);
    const resLastModified = parseUTCDate(resLastModifiedHeader);
    if (resLastModified <= reqIfModifiedSince) {
      return new Response(null, { status: 304, headers: res.headers });
    }
  }
  if (res.ranges.length > 0) {
    res.status = 206;
    if (res.ranges.length > 1) {
      (0, import_assert9.default)(!(res.body instanceof import_web4.ReadableStream));
      res.headers.set("Content-Type", res.body.multipartContentType);
    } else {
      const { start, end } = res.ranges[0];
      res.headers.set(
        "Content-Range",
        `bytes ${start}-${end}/${res.totalSize}`
      );
      res.headers.set("Content-Length", `${end - start + 1}`);
    }
  }
  if (!(res.body instanceof import_web4.ReadableStream))
    res.body = res.body.body;
  return new Response(res.body, { status: res.status, headers: res.headers });
}
var _responses, _ready, _listen;
var __HttpParser = class {
  constructor() {
    __privateAdd(this, _responses, /* @__PURE__ */ new Map());
    __privateAdd(this, _ready, void 0);
    __privateAdd(this, _listen, async (req, res) => {
      (0, import_assert9.default)(req.url !== void 0);
      (0, import_assert9.default)(res.socket !== null);
      const stream = __privateGet(this, _responses).get(req.url);
      (0, import_assert9.default)(stream !== void 0);
      for await (const chunk of stream)
        res.socket.write(chunk);
      res.socket.end();
    });
    const server = import_http6.default.createServer(__privateGet(this, _listen)).unref();
    __privateSet(this, _ready, new Promise((resolve) => {
      server.listen(0, "localhost", () => {
        const address = server.address();
        (0, import_assert9.default)(address !== null && typeof address === "object");
        resolve(new URL(`http://localhost:${address.port}`));
      });
    }));
  }
  static get() {
    __HttpParser.INSTANCE ??= new __HttpParser();
    return __HttpParser.INSTANCE;
  }
  async parse(response) {
    const baseURL = await __privateGet(this, _ready);
    const id = `/${import_crypto4.default.randomBytes(16).toString("hex")}`;
    __privateGet(this, _responses).set(id, response);
    try {
      return await fetch2(new URL(id, baseURL));
    } finally {
      __privateGet(this, _responses).delete(id);
    }
  }
};
var _HttpParser = __HttpParser;
_responses = new WeakMap();
_ready = new WeakMap();
_listen = new WeakMap();
__publicField(_HttpParser, "INSTANCE");
var SizingStream = class extends import_web4.TransformStream {
  size;
  constructor() {
    const sizePromise = new DeferredPromise();
    let size = 0;
    super({
      transform(chunk, controller) {
        size += chunk.byteLength;
        controller.enqueue(chunk);
      },
      flush() {
        sizePromise.resolve(size);
      }
    });
    this.size = sizePromise;
  }
};
var CacheGateway = class {
  constructor(log, storage, timers) {
    this.log = log;
    this.timers = timers;
    this.storage = new KeyValueStorage(storage, timers);
  }
  storage;
  async match(request, cacheKey) {
    if (isSitesRequest(request))
      throw new CacheMiss();
    cacheKey ??= request.url;
    let resHeaders;
    let resRanges;
    const cached = await this.storage.get(cacheKey, ({ size, headers }) => {
      resHeaders = new import_undici8.Headers(headers);
      const contentType = resHeaders.get("Content-Type");
      const rangeHeader = request.headers.get("Range");
      if (rangeHeader !== null) {
        resRanges = _parseRanges(rangeHeader, size);
        if (resRanges === void 0)
          throw new RangeNotSatisfiable(size);
      }
      return {
        ranges: resRanges,
        contentLength: size,
        contentType: contentType ?? void 0
      };
    });
    if (cached?.metadata === void 0)
      throw new CacheMiss();
    (0, import_assert9.default)(resHeaders !== void 0);
    resHeaders.set("CF-Cache-Status", "HIT");
    resRanges ??= [];
    return getMatchResponse(request.headers, {
      status: cached.metadata.status,
      headers: resHeaders,
      ranges: resRanges,
      body: cached.value,
      totalSize: cached.metadata.size
    });
  }
  async put(request, value, cacheKey) {
    if (isSitesRequest(request))
      return new Response(null, { status: 204 });
    const response = await _HttpParser.get().parse(value);
    let body = response.body;
    (0, import_assert9.default)(body !== null);
    const { storable, expiration, headers } = getExpiration(
      this.timers,
      request,
      response
    );
    if (!storable)
      throw new StorageFailure();
    cacheKey ??= request.url;
    const contentLength = parseInt(response.headers.get("Content-Length"));
    let sizePromise;
    if (Number.isNaN(contentLength)) {
      const stream = new SizingStream();
      body = body.pipeThrough(stream);
      sizePromise = stream.size;
    } else {
      sizePromise = Promise.resolve(contentLength);
    }
    const metadata = sizePromise.then((size) => ({
      headers: Object.entries(headers),
      status: response.status,
      size
    }));
    await this.storage.put({
      key: cacheKey,
      value: body,
      expiration: this.timers.now() + expiration,
      metadata
    });
    return new Response(null, { status: 204 });
  }
  async delete(request, cacheKey) {
    cacheKey ??= request.url;
    const deleted = await this.storage.delete(cacheKey);
    if (!deleted)
      throw new PurgeFailure();
    return new Response(null);
  }
};

// packages/miniflare/src/plugins/cache/router.ts
var import_assert10 = __toESM(require("assert"));
var import_web5 = require("stream/web");
function decodeNamespace(headers) {
  const namespace = headers.get("cf-cache-namespace" /* CacheNamespace */);
  return namespace === null ? `default` : `named:${namespace}`;
}
var CR = "\r".charCodeAt(0);
var LF = "\n".charCodeAt(0);
var _RemoveTransformEncodingChunkedStream = class extends import_web5.TransformStream {
  constructor() {
    let buffer = Buffer.alloc(0);
    let replaced = false;
    super({
      transform(chunk, controller) {
        if (replaced) {
          controller.enqueue(chunk);
        } else {
          buffer = Buffer.concat([buffer, chunk]);
          const endOfHeadersIndex = buffer.findIndex(
            (_value, index) => buffer[index] === CR && buffer[index + 1] === LF && buffer[index + 2] === CR && buffer[index + 3] === LF
          );
          if (endOfHeadersIndex !== -1) {
            const headers = buffer.subarray(0, endOfHeadersIndex).toString();
            const replacedHeaders = headers.replace(
              /\r\nTransfer-Encoding: chunked/i,
              ""
            );
            controller.enqueue(Buffer.from(replacedHeaders, "utf8"));
            controller.enqueue(buffer.subarray(endOfHeadersIndex));
            replaced = true;
          }
        }
      },
      flush(controller) {
        if (!replaced)
          controller.enqueue(buffer);
      }
    });
  }
};
var CacheRouter = class extends Router {
  #warnedUsage = false;
  #maybeWarnUsage(headers) {
    if (!this.#warnedUsage && headers.get(HEADER_CACHE_WARN_USAGE) === "true") {
      this.#warnedUsage = true;
      this.log.warn(
        "Cache operations will have no impact if you deploy to a workers.dev subdomain!"
      );
    }
  }
  match = async (req, params) => {
    this.#maybeWarnUsage(req.headers);
    const uri = decodeURIComponent(params.uri);
    const namespace = decodeNamespace(req.headers);
    const persist = decodePersist(req.headers);
    const gateway = this.gatewayFactory.get(namespace, persist);
    const key = new Request(uri, req);
    return gateway.match(key, req.cf?.cacheKey);
  };
  put = async (req, params) => {
    this.#maybeWarnUsage(req.headers);
    const uri = decodeURIComponent(params.uri);
    const namespace = decodeNamespace(req.headers);
    const persist = decodePersist(req.headers);
    const gateway = this.gatewayFactory.get(namespace, persist);
    const key = new Request(uri, { ...req, body: void 0 });
    const removerStream = new _RemoveTransformEncodingChunkedStream();
    (0, import_assert10.default)(req.body !== null);
    const bodyStream = req.body.pipeThrough(removerStream);
    return gateway.put(key, bodyStream, req.cf?.cacheKey);
  };
  delete = async (req, params) => {
    this.#maybeWarnUsage(req.headers);
    const uri = decodeURIComponent(params.uri);
    const namespace = decodeNamespace(req.headers);
    const persist = decodePersist(req.headers);
    const gateway = this.gatewayFactory.get(namespace, persist);
    const key = new Request(uri, req);
    return gateway.delete(key, req.cf?.cacheKey);
  };
};
__decorateClass([
  GET("/:uri")
], CacheRouter.prototype, "match", 2);
__decorateClass([
  PUT("/:uri")
], CacheRouter.prototype, "put", 2);
__decorateClass([
  PURGE("/:uri")
], CacheRouter.prototype, "delete", 2);

// packages/miniflare/src/plugins/cache/index.ts
var CacheOptionsSchema = import_zod7.z.object({
  cache: import_zod7.z.boolean().optional(),
  cacheWarnUsage: import_zod7.z.boolean().optional()
});
var CacheSharedOptionsSchema = import_zod7.z.object({
  cachePersist: PersistenceSchema
});
var BINDING_JSON_CACHE_WARN_USAGE = "MINIFLARE_CACHE_WARN_USAGE";
var CACHE_SCRIPT_COMPAT_DATE = "2022-09-01";
var CACHE_LOOPBACK_SCRIPT = `addEventListener("fetch", (event) => {
  const request = new Request(event.request);
  const url = new URL(request.url);
  url.pathname = \`/\${${BINDING_TEXT_PLUGIN}}/\${encodeURIComponent(request.url)}\`;
  if (globalThis.${BINDING_TEXT_PERSIST} !== undefined) request.headers.set("${HEADER_PERSIST}", ${BINDING_TEXT_PERSIST});
  if (globalThis.${BINDING_JSON_CACHE_WARN_USAGE}) request.headers.set("${HEADER_CACHE_WARN_USAGE}", "true");
  event.respondWith(${CoreBindings.SERVICE_LOOPBACK}.fetch(url, request));
});`;
var NOOP_CACHE_SCRIPT = `addEventListener("fetch", (event) => {
  const request = event.request;
  if (request.method === "GET") {
    event.respondWith(new Response(null, { status: 504, headers: { [${JSON.stringify(
  "cf-cache-status" /* CacheStatus */
)}]: "MISS" } }));
  } else if (request.method === "PUT") {
    // Must consume request body, otherwise get "disconnected: read end of pipe was aborted" error from workerd
    event.respondWith(request.arrayBuffer().then(() => new Response(null, { status: 204 })));
  } else if (request.method === "PURGE") {
    event.respondWith(new Response(null, { status: 404 }));
  } else {
    event.respondWith(new Response(null, { status: 405 }));
  }
});`;
var CACHE_PLUGIN_NAME = "cache";
function getCacheServiceName(workerIndex) {
  return `${CACHE_PLUGIN_NAME}:${workerIndex}`;
}
var CACHE_PLUGIN = {
  gateway: CacheGateway,
  router: CacheRouter,
  options: CacheOptionsSchema,
  sharedOptions: CacheSharedOptionsSchema,
  getBindings() {
    return [];
  },
  getNodeBindings() {
    return {};
  },
  getServices({ sharedOptions, options, workerIndex }) {
    const persistBinding = encodePersist(sharedOptions.cachePersist);
    return [
      {
        name: getCacheServiceName(workerIndex),
        worker: {
          serviceWorkerScript: (
            // If options.cache is undefined, default to enabling cache
            options.cache === false ? NOOP_CACHE_SCRIPT : CACHE_LOOPBACK_SCRIPT
          ),
          bindings: [
            ...persistBinding,
            { name: BINDING_TEXT_PLUGIN, text: CACHE_PLUGIN_NAME },
            {
              name: BINDING_JSON_CACHE_WARN_USAGE,
              json: JSON.stringify(options.cacheWarnUsage ?? false)
            },
            WORKER_BINDING_SERVICE_LOOPBACK
          ],
          compatibilityDate: CACHE_SCRIPT_COMPAT_DATE
        }
      }
    ];
  }
};

// packages/miniflare/src/plugins/core/index.ts
var import_assert16 = __toESM(require("assert"));
var import_fs5 = require("fs");
var import_promises6 = __toESM(require("fs/promises"));
var import_path11 = __toESM(require("path"));
var import_tls = __toESM(require("tls"));
var import_util3 = require("util");
var import_colors5 = require("kleur/colors");
var import_undici7 = require("undici");

// embed-worker:/Users/bcoll/Projects/miniflare3-prs/packages/miniflare/src/workers/core/entry.worker.ts
var entry_worker_default = '// node_modules/devalue/src/utils.js\nvar escaped = {\n  "<": "\\\\u003C",\n  ">": "\\\\u003E",\n  "/": "\\\\u002F",\n  "\\\\": "\\\\\\\\",\n  "\\b": "\\\\b",\n  "\\f": "\\\\f",\n  "\\n": "\\\\n",\n  "\\r": "\\\\r",\n  "	": "\\\\t",\n  "\\0": "\\\\u0000",\n  "\\u2028": "\\\\u2028",\n  "\\u2029": "\\\\u2029"\n};\nvar DevalueError = class extends Error {\n  /**\n   * @param {string} message\n   * @param {string[]} keys\n   */\n  constructor(message, keys) {\n    super(message);\n    this.name = "DevalueError";\n    this.path = keys.join("");\n  }\n};\nfunction is_primitive(thing) {\n  return Object(thing) !== thing;\n}\nvar object_proto_names = Object.getOwnPropertyNames(Object.prototype).sort().join("\\0");\nfunction is_plain_object(thing) {\n  const proto = Object.getPrototypeOf(thing);\n  return proto === Object.prototype || proto === null || Object.getOwnPropertyNames(proto).sort().join("\\0") === object_proto_names;\n}\nfunction get_type(thing) {\n  return Object.prototype.toString.call(thing).slice(8, -1);\n}\nfunction stringify_string(str) {\n  let result = \'"\';\n  for (let i = 0; i < str.length; i += 1) {\n    const char = str.charAt(i);\n    const code = char.charCodeAt(0);\n    if (char === \'"\') {\n      result += \'\\\\"\';\n    } else if (char in escaped) {\n      result += escaped[char];\n    } else if (code <= 31) {\n      result += `\\\\u${code.toString(16).toUpperCase().padStart(4, "0")}`;\n    } else if (code >= 55296 && code <= 57343) {\n      const next = str.charCodeAt(i + 1);\n      if (code <= 56319 && next >= 56320 && next <= 57343) {\n        result += char + str[++i];\n      } else {\n        result += `\\\\u${code.toString(16).toUpperCase()}`;\n      }\n    } else {\n      result += char;\n    }\n  }\n  result += \'"\';\n  return result;\n}\n\n// node_modules/devalue/src/constants.js\nvar UNDEFINED = -1;\nvar HOLE = -2;\nvar NAN = -3;\nvar POSITIVE_INFINITY = -4;\nvar NEGATIVE_INFINITY = -5;\nvar NEGATIVE_ZERO = -6;\n\n// node_modules/devalue/src/parse.js\nfunction parse(serialized, revivers) {\n  return unflatten(JSON.parse(serialized), revivers);\n}\nfunction unflatten(parsed, revivers) {\n  if (typeof parsed === "number")\n    return hydrate(parsed, true);\n  if (!Array.isArray(parsed) || parsed.length === 0) {\n    throw new Error("Invalid input");\n  }\n  const values = (\n    /** @type {any[]} */\n    parsed\n  );\n  const hydrated = Array(values.length);\n  function hydrate(index, standalone = false) {\n    if (index === UNDEFINED)\n      return void 0;\n    if (index === NAN)\n      return NaN;\n    if (index === POSITIVE_INFINITY)\n      return Infinity;\n    if (index === NEGATIVE_INFINITY)\n      return -Infinity;\n    if (index === NEGATIVE_ZERO)\n      return -0;\n    if (standalone)\n      throw new Error(`Invalid input`);\n    if (index in hydrated)\n      return hydrated[index];\n    const value = values[index];\n    if (!value || typeof value !== "object") {\n      hydrated[index] = value;\n    } else if (Array.isArray(value)) {\n      if (typeof value[0] === "string") {\n        const type = value[0];\n        const reviver = revivers?.[type];\n        if (reviver) {\n          return hydrated[index] = reviver(hydrate(value[1]));\n        }\n        switch (type) {\n          case "Date":\n            hydrated[index] = new Date(value[1]);\n            break;\n          case "Set":\n            const set = /* @__PURE__ */ new Set();\n            hydrated[index] = set;\n            for (let i = 1; i < value.length; i += 1) {\n              set.add(hydrate(value[i]));\n            }\n            break;\n          case "Map":\n            const map = /* @__PURE__ */ new Map();\n            hydrated[index] = map;\n            for (let i = 1; i < value.length; i += 2) {\n              map.set(hydrate(value[i]), hydrate(value[i + 1]));\n            }\n            break;\n          case "RegExp":\n            hydrated[index] = new RegExp(value[1], value[2]);\n            break;\n          case "Object":\n            hydrated[index] = Object(value[1]);\n            break;\n          case "BigInt":\n            hydrated[index] = BigInt(value[1]);\n            break;\n          case "null":\n            const obj = /* @__PURE__ */ Object.create(null);\n            hydrated[index] = obj;\n            for (let i = 1; i < value.length; i += 2) {\n              obj[value[i]] = hydrate(value[i + 1]);\n            }\n            break;\n          default:\n            throw new Error(`Unknown type ${type}`);\n        }\n      } else {\n        const array = new Array(value.length);\n        hydrated[index] = array;\n        for (let i = 0; i < value.length; i += 1) {\n          const n = value[i];\n          if (n === HOLE)\n            continue;\n          array[i] = hydrate(n);\n        }\n      }\n    } else {\n      const object = {};\n      hydrated[index] = object;\n      for (const key in value) {\n        const n = value[key];\n        object[key] = hydrate(n);\n      }\n    }\n    return hydrated[index];\n  }\n  return hydrate(0);\n}\n\n// node_modules/devalue/src/stringify.js\nfunction stringify(value, reducers) {\n  const stringified = [];\n  const indexes = /* @__PURE__ */ new Map();\n  const custom = [];\n  for (const key in reducers) {\n    custom.push({ key, fn: reducers[key] });\n  }\n  const keys = [];\n  let p = 0;\n  function flatten(thing) {\n    if (typeof thing === "function") {\n      throw new DevalueError(`Cannot stringify a function`, keys);\n    }\n    if (indexes.has(thing))\n      return indexes.get(thing);\n    if (thing === void 0)\n      return UNDEFINED;\n    if (Number.isNaN(thing))\n      return NAN;\n    if (thing === Infinity)\n      return POSITIVE_INFINITY;\n    if (thing === -Infinity)\n      return NEGATIVE_INFINITY;\n    if (thing === 0 && 1 / thing < 0)\n      return NEGATIVE_ZERO;\n    const index2 = p++;\n    indexes.set(thing, index2);\n    for (const { key, fn } of custom) {\n      const value2 = fn(thing);\n      if (value2) {\n        stringified[index2] = `["${key}",${flatten(value2)}]`;\n        return index2;\n      }\n    }\n    let str = "";\n    if (is_primitive(thing)) {\n      str = stringify_primitive(thing);\n    } else {\n      const type = get_type(thing);\n      switch (type) {\n        case "Number":\n        case "String":\n        case "Boolean":\n          str = `["Object",${stringify_primitive(thing)}]`;\n          break;\n        case "BigInt":\n          str = `["BigInt",${thing}]`;\n          break;\n        case "Date":\n          str = `["Date","${thing.toISOString()}"]`;\n          break;\n        case "RegExp":\n          const { source, flags } = thing;\n          str = flags ? `["RegExp",${stringify_string(source)},"${flags}"]` : `["RegExp",${stringify_string(source)}]`;\n          break;\n        case "Array":\n          str = "[";\n          for (let i = 0; i < thing.length; i += 1) {\n            if (i > 0)\n              str += ",";\n            if (i in thing) {\n              keys.push(`[${i}]`);\n              str += flatten(thing[i]);\n              keys.pop();\n            } else {\n              str += HOLE;\n            }\n          }\n          str += "]";\n          break;\n        case "Set":\n          str = \'["Set"\';\n          for (const value2 of thing) {\n            str += `,${flatten(value2)}`;\n          }\n          str += "]";\n          break;\n        case "Map":\n          str = \'["Map"\';\n          for (const [key, value2] of thing) {\n            keys.push(\n              `.get(${is_primitive(key) ? stringify_primitive(key) : "..."})`\n            );\n            str += `,${flatten(key)},${flatten(value2)}`;\n          }\n          str += "]";\n          break;\n        default:\n          if (!is_plain_object(thing)) {\n            throw new DevalueError(\n              `Cannot stringify arbitrary non-POJOs`,\n              keys\n            );\n          }\n          if (Object.getOwnPropertySymbols(thing).length > 0) {\n            throw new DevalueError(\n              `Cannot stringify POJOs with symbolic keys`,\n              keys\n            );\n          }\n          if (Object.getPrototypeOf(thing) === null) {\n            str = \'["null"\';\n            for (const key in thing) {\n              keys.push(`.${key}`);\n              str += `,${stringify_string(key)},${flatten(thing[key])}`;\n              keys.pop();\n            }\n            str += "]";\n          } else {\n            str = "{";\n            let started = false;\n            for (const key in thing) {\n              if (started)\n                str += ",";\n              started = true;\n              keys.push(`.${key}`);\n              str += `${stringify_string(key)}:${flatten(thing[key])}`;\n              keys.pop();\n            }\n            str += "}";\n          }\n      }\n    }\n    stringified[index2] = str;\n    return index2;\n  }\n  const index = flatten(value);\n  if (index < 0)\n    return `${index}`;\n  return `[${stringified.join(",")}]`;\n}\nfunction stringify_primitive(thing) {\n  const type = typeof thing;\n  if (type === "string")\n    return stringify_string(thing);\n  if (thing instanceof String)\n    return stringify_string(thing.toString());\n  if (thing === void 0)\n    return UNDEFINED.toString();\n  if (thing === 0 && 1 / thing < 0)\n    return NEGATIVE_ZERO.toString();\n  if (type === "bigint")\n    return `["BigInt","${thing}"]`;\n  return String(thing);\n}\n\n// packages/miniflare/src/workers/core/constants.ts\nvar CoreHeaders = {\n  CUSTOM_SERVICE: "MF-Custom-Service",\n  ORIGINAL_URL: "MF-Original-URL",\n  ERROR_STACK: "MF-Experimental-Error-Stack",\n  ROUTE_OVERRIDE: "MF-Route-Override",\n  CUSTOM_EVENT: "MF-Custom-Event",\n  // API Proxy\n  OP: "MF-Op",\n  OP_TARGET: "MF-Op-Target",\n  OP_KEY: "MF-Op-Key",\n  OP_SYNC: "MF-Op-Sync",\n  OP_STRINGIFIED_SIZE: "MF-Op-Stringified-Size",\n  OP_RESULT_TYPE: "MF-Op-Result-Type"\n};\nvar CoreBindings = {\n  SERVICE_LOOPBACK: "MINIFLARE_LOOPBACK",\n  SERVICE_USER_ROUTE_PREFIX: "MINIFLARE_USER_ROUTE_",\n  SERVICE_USER_FALLBACK: "MINIFLARE_USER_FALLBACK",\n  TEXT_CUSTOM_SERVICE: "MINIFLARE_CUSTOM_SERVICE",\n  TEXT_UPSTREAM_URL: "MINIFLARE_UPSTREAM_URL",\n  JSON_CF_BLOB: "CF_BLOB",\n  JSON_ROUTES: "MINIFLARE_ROUTES",\n  JSON_LOG_LEVEL: "MINIFLARE_LOG_LEVEL",\n  DATA_LIVE_RELOAD_SCRIPT: "MINIFLARE_LIVE_RELOAD_SCRIPT",\n  DURABLE_OBJECT_NAMESPACE_PROXY: "MINIFLARE_PROXY"\n};\nvar ProxyOps = {\n  // Get the target or a property of the target\n  GET: "GET",\n  // Call a method on the target\n  CALL: "CALL",\n  // Remove the strong reference to the target on the "heap", allowing it to be\n  // garbage collected\n  FREE: "FREE"\n};\nvar ProxyAddresses = {\n  GLOBAL: 0,\n  // globalThis\n  ENV: 1,\n  // env\n  USER_START: 2\n};\nfunction isFetcherFetch(targetName, key) {\n  return (targetName === "Fetcher" || targetName === "DurableObject") && key === "fetch";\n}\nfunction isR2ObjectWriteHttpMetadata(targetName, key) {\n  return (targetName === "HeadResult" || targetName === "GetResult") && key === "writeHttpMetadata";\n}\n\n// packages/miniflare/src/workers/core/devalue.ts\nimport assert from "node:assert";\nimport { Buffer } from "node:buffer";\nvar ALLOWED_ARRAY_BUFFER_VIEW_CONSTRUCTORS = [\n  DataView,\n  Int8Array,\n  Uint8Array,\n  Uint8ClampedArray,\n  Int16Array,\n  Uint16Array,\n  Int32Array,\n  Uint32Array,\n  Float32Array,\n  Float64Array,\n  BigInt64Array,\n  BigUint64Array\n];\nvar ALLOWED_ERROR_CONSTRUCTORS = [\n  EvalError,\n  RangeError,\n  ReferenceError,\n  SyntaxError,\n  TypeError,\n  URIError,\n  Error\n  // `Error` last so more specific error subclasses preferred\n];\nvar structuredSerializableReducers = {\n  ArrayBuffer(value) {\n    if (value instanceof ArrayBuffer) {\n      return [Buffer.from(value).toString("base64")];\n    }\n  },\n  ArrayBufferView(value) {\n    if (ArrayBuffer.isView(value)) {\n      return [\n        value.constructor.name,\n        value.buffer,\n        value.byteOffset,\n        value.byteLength\n      ];\n    }\n  },\n  Error(value) {\n    for (const ctor of ALLOWED_ERROR_CONSTRUCTORS) {\n      if (value instanceof ctor && value.name === ctor.name) {\n        return [value.name, value.message, value.stack, value.cause];\n      }\n    }\n    if (value instanceof Error) {\n      return ["Error", value.message, value.stack, value.cause];\n    }\n  }\n};\nvar structuredSerializableRevivers = {\n  ArrayBuffer(value) {\n    assert(Array.isArray(value));\n    const [encoded] = value;\n    assert(typeof encoded === "string");\n    const view = Buffer.from(encoded, "base64");\n    return view.buffer.slice(\n      view.byteOffset,\n      view.byteOffset + view.byteLength\n    );\n  },\n  ArrayBufferView(value) {\n    assert(Array.isArray(value));\n    const [name, buffer, byteOffset, byteLength] = value;\n    assert(typeof name === "string");\n    assert(buffer instanceof ArrayBuffer);\n    assert(typeof byteOffset === "number");\n    assert(typeof byteLength === "number");\n    const ctor = globalThis[name];\n    assert(ALLOWED_ARRAY_BUFFER_VIEW_CONSTRUCTORS.includes(ctor));\n    let length = byteLength;\n    if ("BYTES_PER_ELEMENT" in ctor)\n      length /= ctor.BYTES_PER_ELEMENT;\n    return new ctor(buffer, byteOffset, length);\n  },\n  Error(value) {\n    assert(Array.isArray(value));\n    const [name, message, stack, cause] = value;\n    assert(typeof name === "string");\n    assert(typeof message === "string");\n    assert(stack === void 0 || typeof stack === "string");\n    const ctor = globalThis[name];\n    assert(ALLOWED_ERROR_CONSTRUCTORS.includes(ctor));\n    const error = new ctor(message, { cause });\n    error.stack = stack;\n    return error;\n  }\n};\nfunction createHTTPReducers(impl) {\n  return {\n    Headers(val) {\n      if (val instanceof impl.Headers)\n        return Object.fromEntries(val);\n    },\n    Request(val) {\n      if (val instanceof impl.Request) {\n        return [val.method, val.url, val.headers, val.cf, val.body];\n      }\n    },\n    Response(val) {\n      if (val instanceof impl.Response) {\n        return [val.status, val.statusText, val.headers, val.cf, val.body];\n      }\n    }\n  };\n}\nfunction createHTTPRevivers(impl) {\n  return {\n    Headers(value) {\n      assert(typeof value === "object" && value !== null);\n      return new impl.Headers(value);\n    },\n    Request(value) {\n      assert(Array.isArray(value));\n      const [method, url, headers, cf, body] = value;\n      assert(typeof method === "string");\n      assert(typeof url === "string");\n      assert(headers instanceof impl.Headers);\n      assert(body === null || impl.isReadableStream(body));\n      return new impl.Request(url, {\n        method,\n        headers,\n        cf,\n        // @ts-expect-error `duplex` is not required by `workerd` yet\n        duplex: body === null ? void 0 : "half",\n        body\n      });\n    },\n    Response(value) {\n      assert(Array.isArray(value));\n      const [status, statusText, headers, cf, body] = value;\n      assert(typeof status === "number");\n      assert(typeof statusText === "string");\n      assert(headers instanceof impl.Headers);\n      assert(body === null || impl.isReadableStream(body));\n      return new impl.Response(body, {\n        status,\n        statusText,\n        headers,\n        cf\n      });\n    }\n  };\n}\nfunction stringifyWithStreams(impl, value, reducers, allowUnbufferedStream) {\n  let unbufferedStream;\n  const bufferPromises = [];\n  const streamReducers = {\n    ReadableStream(value2) {\n      if (impl.isReadableStream(value2)) {\n        if (allowUnbufferedStream && unbufferedStream === void 0) {\n          unbufferedStream = value2;\n        } else {\n          bufferPromises.push(impl.bufferReadableStream(value2));\n        }\n        return true;\n      }\n    },\n    Blob(value2) {\n      if (value2 instanceof impl.Blob) {\n        bufferPromises.push(value2.arrayBuffer());\n        return true;\n      }\n    },\n    ...reducers\n  };\n  const stringifiedValue = stringify(value, streamReducers);\n  if (bufferPromises.length === 0) {\n    return { value: stringifiedValue, unbufferedStream };\n  }\n  return Promise.all(bufferPromises).then((streamBuffers) => {\n    streamReducers.ReadableStream = function(value2) {\n      if (impl.isReadableStream(value2)) {\n        if (value2 === unbufferedStream) {\n          return true;\n        } else {\n          return streamBuffers.shift();\n        }\n      }\n    };\n    streamReducers.Blob = function(value2) {\n      if (value2 instanceof impl.Blob) {\n        const array = [streamBuffers.shift(), value2.type];\n        if (value2 instanceof impl.File) {\n          array.push(value2.name, value2.lastModified);\n        }\n        return array;\n      }\n    };\n    const stringifiedValue2 = stringify(value, streamReducers);\n    return { value: stringifiedValue2, unbufferedStream };\n  });\n}\nfunction parseWithReadableStreams(impl, stringified, revivers) {\n  const streamRevivers = {\n    ReadableStream(value) {\n      if (value === true) {\n        assert(stringified.unbufferedStream !== void 0);\n        return stringified.unbufferedStream;\n      }\n      assert(value instanceof ArrayBuffer);\n      return impl.unbufferReadableStream(value);\n    },\n    Blob(value) {\n      assert(Array.isArray(value));\n      if (value.length === 2) {\n        const [buffer, type] = value;\n        assert(buffer instanceof ArrayBuffer);\n        assert(typeof type === "string");\n        const opts = {};\n        if (type !== "")\n          opts.type = type;\n        return new impl.Blob([buffer], opts);\n      } else {\n        assert(value.length === 4);\n        const [buffer, type, name, lastModified] = value;\n        assert(buffer instanceof ArrayBuffer);\n        assert(typeof type === "string");\n        assert(typeof name === "string");\n        assert(typeof lastModified === "number");\n        const opts = { lastModified };\n        if (type !== "")\n          opts.type = type;\n        return new impl.File([buffer], name, opts);\n      }\n    },\n    ...revivers\n  };\n  return parse(stringified.value, streamRevivers);\n}\n\n// packages/miniflare/src/workers/core/routing.ts\nfunction matchRoutes(routes, url) {\n  for (const route of routes) {\n    if (route.protocol && route.protocol !== url.protocol)\n      continue;\n    if (route.allowHostnamePrefix) {\n      if (!url.hostname.endsWith(route.hostname))\n        continue;\n    } else {\n      if (url.hostname !== route.hostname)\n        continue;\n    }\n    const path = url.pathname + url.search;\n    if (route.allowPathSuffix) {\n      if (!path.startsWith(route.path))\n        continue;\n    } else {\n      if (path !== route.path)\n        continue;\n    }\n    return route.target;\n  }\n  return null;\n}\n\n// packages/miniflare/src/workers/core/proxy.worker.ts\nimport assert2 from "node:assert";\nvar ENCODER = new TextEncoder();\nvar DECODER = new TextDecoder();\nvar WORKERS_PLATFORM_IMPL = {\n  Blob,\n  File,\n  Headers,\n  Request,\n  Response,\n  isReadableStream(value) {\n    return value instanceof ReadableStream;\n  },\n  bufferReadableStream(stream) {\n    return new Response(stream).arrayBuffer();\n  },\n  unbufferReadableStream(buffer) {\n    const body = new Response(buffer).body;\n    assert2(body !== null);\n    return body;\n  }\n};\nfunction reduceError(e) {\n  return {\n    name: e?.name,\n    message: e?.message ?? String(e),\n    stack: e?.stack,\n    cause: e?.cause === void 0 ? void 0 : reduceError(e.cause)\n  };\n}\nasync function readPrefix(stream, prefixLength) {\n  const reader = await stream.getReader({ mode: "byob" });\n  const result = await reader.readAtLeast(\n    prefixLength,\n    new Uint8Array(prefixLength)\n  );\n  assert2(result.value !== void 0);\n  reader.releaseLock();\n  const rest = stream.pipeThrough(new IdentityTransformStream());\n  return [result.value, rest];\n}\nvar objectProtoNames = Object.getOwnPropertyNames(Object.prototype).sort().join("\\0");\nfunction isPlainObject(value) {\n  const proto = Object.getPrototypeOf(value);\n  return proto === Object.prototype || proto === null || Object.getOwnPropertyNames(proto).sort().join("\\0") === objectProtoNames;\n}\nfunction getType(value) {\n  return Object.prototype.toString.call(value).slice(8, -1);\n}\nvar ProxyServer = class {\n  // On the first `fetch()`, start a `setInterval()` to keep this Durable Object\n  // and its heap alive. This is required to ensure heap references stay valid\n  // for the lifetime of this `workerd` process (except it isn\'t since `workerd`\n  // doesn\'t evict Durable Objects yet :P, but it probably will soon).\n  anchorInterval;\n  nextHeapAddress = ProxyAddresses.USER_START;\n  heap = /* @__PURE__ */ new Map();\n  reducers = {\n    ...structuredSerializableReducers,\n    ...createHTTPReducers(WORKERS_PLATFORM_IMPL),\n    // Corresponding revivers in `ProxyClient`\n    // `Native` reducer *MUST* be applied last\n    Native: (value) => {\n      const type = getType(value);\n      if (type === "Object" && !isPlainObject(value) || type === "Promise") {\n        const address = this.nextHeapAddress++;\n        this.heap.set(address, value);\n        assert2(typeof value === "object" && value !== null);\n        return [address, value.constructor.name];\n      }\n    }\n  };\n  revivers = {\n    ...structuredSerializableRevivers,\n    ...createHTTPRevivers(WORKERS_PLATFORM_IMPL),\n    // Corresponding reducers in `ProxyClient`\n    Native: (value) => {\n      assert2(Array.isArray(value));\n      const [address] = value;\n      assert2(typeof address === "number");\n      const heapValue = this.heap.get(address);\n      assert2(heapValue !== void 0);\n      if (heapValue instanceof Promise)\n        this.heap.delete(address);\n      return heapValue;\n    }\n  };\n  nativeReviver = { Native: this.revivers.Native };\n  constructor(_state, env) {\n    this.heap.set(ProxyAddresses.GLOBAL, globalThis);\n    this.heap.set(ProxyAddresses.ENV, env);\n  }\n  async fetch(request) {\n    this.anchorInterval ??= setInterval(() => {\n    }, 1e4);\n    try {\n      return await this.#fetch(request);\n    } catch (e) {\n      const error = reduceError(e);\n      return Response.json(error, {\n        status: 500,\n        headers: { [CoreHeaders.ERROR_STACK]: "true" }\n      });\n    }\n  }\n  async #fetch(request) {\n    const opHeader = request.headers.get(CoreHeaders.OP);\n    const targetHeader = request.headers.get(CoreHeaders.OP_TARGET);\n    const keyHeader = request.headers.get(CoreHeaders.OP_KEY);\n    const allowAsync = request.headers.get(CoreHeaders.OP_SYNC) === null;\n    const argsSizeHeader = request.headers.get(CoreHeaders.OP_STRINGIFIED_SIZE);\n    const contentLengthHeader = request.headers.get("Content-Length");\n    if (targetHeader === null)\n      return new Response(null, { status: 400 });\n    if (opHeader === ProxyOps.FREE) {\n      const targetAddress = parseInt(targetHeader);\n      assert2(!Number.isNaN(targetAddress));\n      this.heap.delete(targetAddress);\n      return new Response(null, { status: 204 });\n    }\n    const target = parse(\n      targetHeader,\n      this.nativeReviver\n    );\n    const targetName = target.constructor.name;\n    let status = 200;\n    let result;\n    let unbufferedRest;\n    if (opHeader === ProxyOps.GET) {\n      result = keyHeader === null ? target : target[keyHeader];\n      if (typeof result === "function") {\n        return new Response(null, {\n          status: 204,\n          headers: { [CoreHeaders.OP_RESULT_TYPE]: "Function" }\n        });\n      }\n    } else if (opHeader === ProxyOps.CALL) {\n      if (keyHeader === null)\n        return new Response(null, { status: 400 });\n      const func = target[keyHeader];\n      assert2(typeof func === "function");\n      if (isFetcherFetch(targetName, keyHeader)) {\n        request = new Request(request);\n        request.headers.delete(CoreHeaders.OP);\n        request.headers.delete(CoreHeaders.OP_TARGET);\n        request.headers.delete(CoreHeaders.OP_KEY);\n        return func.call(target, request);\n      }\n      let args;\n      if (argsSizeHeader === null || argsSizeHeader === contentLengthHeader) {\n        args = parseWithReadableStreams(\n          WORKERS_PLATFORM_IMPL,\n          { value: await request.text() },\n          this.revivers\n        );\n      } else {\n        const argsSize = parseInt(argsSizeHeader);\n        assert2(!Number.isNaN(argsSize));\n        assert2(request.body !== null);\n        const [encodedArgs, rest] = await readPrefix(request.body, argsSize);\n        unbufferedRest = rest;\n        const stringifiedArgs = DECODER.decode(encodedArgs);\n        args = parseWithReadableStreams(\n          WORKERS_PLATFORM_IMPL,\n          { value: stringifiedArgs, unbufferedStream: rest },\n          this.revivers\n        );\n      }\n      assert2(Array.isArray(args));\n      try {\n        result = func.apply(target, args);\n        if (isR2ObjectWriteHttpMetadata(targetName, keyHeader)) {\n          result = args[0];\n        }\n      } catch (e) {\n        status = 500;\n        result = e;\n      }\n    } else {\n      return new Response(null, { status: 404 });\n    }\n    const headers = new Headers();\n    if (allowAsync && result instanceof Promise) {\n      try {\n        result = await result;\n      } catch (e) {\n        status = 500;\n        result = e;\n      }\n      headers.append(CoreHeaders.OP_RESULT_TYPE, "Promise");\n    }\n    if (unbufferedRest !== void 0 && !unbufferedRest.locked) {\n      try {\n        await unbufferedRest.pipeTo(new WritableStream());\n      } catch {\n      }\n    }\n    if (result instanceof ReadableStream) {\n      headers.append(CoreHeaders.OP_RESULT_TYPE, "ReadableStream");\n      return new Response(result, { status, headers });\n    } else {\n      const stringified = await stringifyWithStreams(\n        WORKERS_PLATFORM_IMPL,\n        result,\n        this.reducers,\n        /* allowUnbufferedStream */\n        allowAsync\n      );\n      if (stringified.unbufferedStream === void 0) {\n        return new Response(stringified.value, { status, headers });\n      } else {\n        const body = new IdentityTransformStream();\n        const encodedValue = ENCODER.encode(stringified.value);\n        const encodedSize = encodedValue.byteLength.toString();\n        headers.set(CoreHeaders.OP_STRINGIFIED_SIZE, encodedSize);\n        void this.#writeWithUnbufferedStream(\n          body.writable,\n          encodedValue,\n          stringified.unbufferedStream\n        );\n        return new Response(body.readable, { status, headers });\n      }\n    }\n  }\n  async #writeWithUnbufferedStream(writable, encodedValue, unbufferedStream) {\n    const writer = writable.getWriter();\n    await writer.write(encodedValue);\n    writer.releaseLock();\n    await unbufferedStream.pipeTo(writable);\n  }\n};\n\n// packages/miniflare/src/workers/core/entry.worker.ts\nfunction getUserRequest(request, env) {\n  const originalUrl = request.headers.get(CoreHeaders.ORIGINAL_URL);\n  const upstreamUrl = env[CoreBindings.TEXT_UPSTREAM_URL];\n  let url = new URL(originalUrl ?? request.url);\n  if (upstreamUrl !== void 0) {\n    let path = url.pathname + url.search;\n    if (path.startsWith("/"))\n      path = path.substring(1);\n    url = new URL(path, upstreamUrl);\n  }\n  request = new Request(url, {\n    method: request.method,\n    headers: request.headers,\n    cf: request.cf ?? env[CoreBindings.JSON_CF_BLOB],\n    redirect: request.redirect,\n    body: request.body\n  });\n  request.headers.delete(CoreHeaders.ORIGINAL_URL);\n  return request;\n}\nfunction getTargetService(request, url, env) {\n  let service = env[CoreBindings.SERVICE_USER_FALLBACK];\n  const override = request.headers.get(CoreHeaders.ROUTE_OVERRIDE);\n  request.headers.delete(CoreHeaders.ROUTE_OVERRIDE);\n  const route = override ?? matchRoutes(env[CoreBindings.JSON_ROUTES], url);\n  if (route !== null) {\n    service = env[`${CoreBindings.SERVICE_USER_ROUTE_PREFIX}${route}`];\n  }\n  return service;\n}\nfunction maybePrettifyError(request, response, env) {\n  if (response.status !== 500 || response.headers.get(CoreHeaders.ERROR_STACK) === null) {\n    return response;\n  }\n  const accept = request.headers.get("Accept")?.toLowerCase() ?? "";\n  const userAgent = request.headers.get("User-Agent")?.toLowerCase() ?? "";\n  const acceptsPrettyError = !userAgent.includes("curl/") && (accept.includes("text/html") || accept.includes("*/*") || accept.includes("text/*"));\n  if (acceptsPrettyError) {\n    return env[CoreBindings.SERVICE_LOOPBACK].fetch(\n      "http://localhost/core/error",\n      {\n        method: "POST",\n        headers: request.headers,\n        body: response.body\n      }\n    );\n  } else {\n    return response;\n  }\n}\nfunction maybeInjectLiveReload(response, env, ctx) {\n  const liveReloadScript = env[CoreBindings.DATA_LIVE_RELOAD_SCRIPT];\n  if (liveReloadScript === void 0 || !response.headers.get("Content-Type")?.toLowerCase().includes("text/html")) {\n    return response;\n  }\n  const headers = new Headers(response.headers);\n  const contentLength = parseInt(headers.get("content-length"));\n  if (!isNaN(contentLength)) {\n    headers.set(\n      "content-length",\n      String(contentLength + liveReloadScript.byteLength)\n    );\n  }\n  const { readable, writable } = new IdentityTransformStream();\n  ctx.waitUntil(\n    (async () => {\n      await response.body?.pipeTo(writable, { preventClose: true });\n      const writer = writable.getWriter();\n      await writer.write(liveReloadScript);\n      await writer.close();\n    })()\n  );\n  return new Response(readable, {\n    status: response.status,\n    statusText: response.statusText,\n    headers\n  });\n}\nfunction maybeLogRequest(request, response, env, ctx, startTime) {\n  if (env[CoreBindings.JSON_LOG_LEVEL] < 3 /* INFO */)\n    return;\n  ctx.waitUntil(\n    env[CoreBindings.SERVICE_LOOPBACK].fetch("http://localhost/core/log", {\n      method: "POST",\n      headers: { "Content-Type": "application/json" },\n      body: JSON.stringify({\n        status: response.status,\n        statusText: response.statusText,\n        method: request.method,\n        url: request.url,\n        time: Date.now() - startTime\n      })\n    })\n  );\n}\nfunction handleProxy(request, env) {\n  const ns = env[CoreBindings.DURABLE_OBJECT_NAMESPACE_PROXY];\n  const id = ns.idFromName("");\n  const stub = ns.get(id);\n  return stub.fetch(request);\n}\nasync function handleQueue(request, url, service, startTime) {\n  const queueName = decodeURIComponent(url.pathname.substring(1));\n  const flattened = await request.json();\n  const messages = unflatten(flattened, structuredSerializableRevivers);\n  const queueResponse = await service.queue(queueName, messages);\n  queueResponse.time = Date.now() - startTime;\n  return Response.json(queueResponse);\n}\nasync function handleScheduled(params, service) {\n  const time = params.get("time");\n  const scheduledTime = time ? new Date(parseInt(time)) : void 0;\n  const cron = params.get("cron") ?? void 0;\n  const result = await service.scheduled({\n    scheduledTime,\n    cron\n  });\n  return new Response(result.outcome, {\n    status: result.outcome === "ok" ? 200 : 500\n  });\n}\nvar entry_worker_default = {\n  async fetch(request, env, ctx) {\n    const startTime = Date.now();\n    const isProxy = request.headers.get(CoreHeaders.OP) !== null;\n    if (isProxy)\n      return handleProxy(request, env);\n    const isDispatchFetch = request.headers.get(CoreHeaders.ORIGINAL_URL) !== null;\n    request = getUserRequest(request, env);\n    const url = new URL(request.url);\n    const service = getTargetService(request, url, env);\n    if (service === void 0) {\n      return new Response("No entrypoint worker found", { status: 404 });\n    }\n    try {\n      const customEvent = request.headers.get(CoreHeaders.CUSTOM_EVENT);\n      if (customEvent === "queue") {\n        return await handleQueue(request, url, service, startTime);\n      }\n      if (url.pathname === "/cdn-cgi/mf/scheduled") {\n        return await handleScheduled(url.searchParams, service);\n      }\n      let response = await service.fetch(request);\n      if (!isDispatchFetch) {\n        response = await maybePrettifyError(request, response, env);\n      }\n      response = maybeInjectLiveReload(response, env, ctx);\n      maybeLogRequest(request, response, env, ctx, startTime);\n      return response;\n    } catch (e) {\n      return new Response(e?.stack ?? String(e), { status: 500 });\n    }\n  }\n};\nexport {\n  ProxyServer,\n  entry_worker_default as default\n};\n';

// packages/miniflare/src/plugins/core/index.ts
var import_zod13 = require("zod");

// packages/miniflare/src/runtime/index.ts
var import_assert11 = __toESM(require("assert"));
var import_child_process = __toESM(require("child_process"));
var import_readline = __toESM(require("readline"));
var import_stream = require("stream");
var import_colors3 = require("kleur/colors");
var import_workerd2 = __toESM(require("workerd"));
var import_zod8 = require("zod");

// packages/miniflare/src/runtime/config/index.ts
var import_capnp_ts = require("capnp-ts");

// packages/miniflare/src/runtime/config/workerd.ts
var import_workerd_capnp = __toESM(require_workerd_capnp());
var kVoid = Symbol("kVoid");

// packages/miniflare/src/runtime/config/index.ts
var import_workerd_capnp2 = __toESM(require_workerd_capnp());
function capitalize(str) {
  return str.length > 0 ? str[0].toUpperCase() + str.substring(1) : str;
}
function encodeCapnpStruct(obj, struct) {
  const anyStruct = struct;
  for (const [key, value] of Object.entries(obj)) {
    const capitalized = capitalize(key);
    if (value instanceof Uint8Array) {
      const newData = anyStruct[`init${capitalized}`](value.byteLength);
      newData.copyBuffer(value);
    } else if (Array.isArray(value)) {
      const newList = anyStruct[`init${capitalized}`](value.length);
      for (let i = 0; i < value.length; i++) {
        if (typeof value[i] === "object") {
          encodeCapnpStruct(value[i], newList.get(i));
        } else {
          newList.set(i, value[i]);
        }
      }
    } else if (typeof value === "object") {
      const newStruct = anyStruct[`init${capitalized}`]();
      encodeCapnpStruct(value, newStruct);
    } else if (value === kVoid) {
      anyStruct[`set${capitalized}`]();
    } else if (value !== void 0) {
      anyStruct[`set${capitalized}`](value);
    }
  }
}
function serializeConfig(config) {
  const message = new import_capnp_ts.Message();
  const struct = message.initRoot(import_workerd_capnp2.Config);
  encodeCapnpStruct(config, struct);
  return Buffer.from(message.toArrayBuffer());
}

// packages/miniflare/src/runtime/index.ts
var ControlMessageSchema = import_zod8.z.object({
  event: import_zod8.z.literal("listen"),
  socket: import_zod8.z.string(),
  port: import_zod8.z.number()
});
async function waitForPort(socket, stream, options) {
  if (options?.signal?.aborted)
    return;
  const lines = import_readline.default.createInterface(stream);
  const abortListener = () => lines.close();
  options?.signal?.addEventListener("abort", abortListener, { once: true });
  try {
    for await (const line of lines) {
      const message = ControlMessageSchema.safeParse(JSON.parse(line));
      if (message.success && message.data.socket === socket) {
        return message.data.port;
      }
    }
  } finally {
    options?.signal?.removeEventListener("abort", abortListener);
  }
}
function waitForExit(process2) {
  return new Promise((resolve) => {
    process2.once("exit", () => resolve());
  });
}
function pipeOutput(runtime) {
  const stdout = import_readline.default.createInterface(runtime.stdout);
  const stderr = import_readline.default.createInterface(runtime.stderr);
  stdout.on("line", (data) => console.log(data));
  stderr.on("line", (data) => console.error((0, import_colors3.red)(data)));
}
var Runtime = class {
  constructor(opts) {
    this.opts = opts;
    this.#command = import_workerd2.default;
  }
  #command;
  #process;
  #processExitPromise;
  get #args() {
    const args = [
      "serve",
      // Required to use binary capnp config
      "--binary",
      // Required to use compatibility flags without a default-on date,
      // (e.g. "streams_enable_constructors"), see https://github.com/cloudflare/workerd/pull/21
      "--experimental",
      `--socket-addr=${SOCKET_ENTRY}=${this.opts.entryHost}:${this.opts.entryPort}`,
      `--external-addr=${SERVICE_LOOPBACK}=localhost:${this.opts.loopbackPort}`,
      // Configure extra pipe for receiving control messages (e.g. when ready)
      "--control-fd=3",
      // Read config from stdin
      "-"
    ];
    if (this.opts.inspectorPort !== void 0) {
      args.push(`--inspector-addr=localhost:${this.opts.inspectorPort}`);
    }
    if (this.opts.verbose) {
      args.push("--verbose");
    }
    return args;
  }
  async updateConfig(configBuffer, options) {
    await this.dispose();
    if (options?.entryPort !== void 0) {
      this.opts.entryPort = options.entryPort;
    }
    const runtimeProcess = import_child_process.default.spawn(this.#command, this.#args, {
      stdio: ["pipe", "pipe", "pipe", "pipe"],
      env: process.env
    });
    this.#process = runtimeProcess;
    this.#processExitPromise = waitForExit(runtimeProcess);
    pipeOutput(runtimeProcess);
    const controlPipe = runtimeProcess.stdio[3];
    (0, import_assert11.default)(controlPipe instanceof import_stream.Readable);
    runtimeProcess.stdin.write(configBuffer);
    runtimeProcess.stdin.end();
    return waitForPort(SOCKET_ENTRY, controlPipe, options);
  }
  dispose() {
    this.#process?.kill("SIGKILL");
    return this.#processExitPromise;
  }
};

// packages/miniflare/src/plugins/do/index.ts
var import_promises5 = __toESM(require("fs/promises"));
var import_path8 = __toESM(require("path"));
var import_url4 = require("url");
var import_zod9 = require("zod");
var DurableObjectsOptionsSchema = import_zod9.z.object({
  durableObjects: import_zod9.z.record(
    import_zod9.z.union([
      import_zod9.z.string(),
      import_zod9.z.object({
        className: import_zod9.z.string(),
        scriptName: import_zod9.z.string().optional(),
        // Allow `uniqueKey` to be customised. We use in Wrangler when setting
        // up stub Durable Objects that proxy requests to Durable Objects in
        // another `workerd` process, to ensure the IDs created by the stub
        // object can be used by the real object too.
        unsafeUniqueKey: import_zod9.z.string().optional()
      })
    ])
  ).optional()
});
var DurableObjectsSharedOptionsSchema = import_zod9.z.object({
  durableObjectsPersist: PersistenceSchema
});
function normaliseDurableObject(designator) {
  const isObject = typeof designator === "object";
  const className = isObject ? designator.className : designator;
  const serviceName = isObject && designator.scriptName !== void 0 ? getUserServiceName(designator.scriptName) : void 0;
  const unsafeUniqueKey = isObject ? designator.unsafeUniqueKey : void 0;
  return { className, serviceName, unsafeUniqueKey };
}
var DURABLE_OBJECTS_PLUGIN_NAME = "do";
var DURABLE_OBJECTS_STORAGE_SERVICE_NAME = `${DURABLE_OBJECTS_PLUGIN_NAME}:storage`;
function normaliseDurableObjectStoragePath(tmpPath, persist) {
  const memoryishPath = import_path8.default.join(tmpPath, DURABLE_OBJECTS_PLUGIN_NAME);
  if (persist === void 0 || persist === false) {
    return memoryishPath;
  }
  const url = maybeParseURL(persist);
  if (url !== void 0) {
    if (url.protocol === "memory:") {
      return memoryishPath;
    } else if (url.protocol === "file:") {
      return (0, import_url4.fileURLToPath)(url);
    }
    throw new MiniflareCoreError(
      "ERR_PERSIST_UNSUPPORTED",
      `Unsupported "${url.protocol}" persistence protocol for Durable Object storage: ${url.href}`
    );
  }
  return persist === true ? import_path8.default.join(DEFAULT_PERSIST_ROOT, DURABLE_OBJECTS_PLUGIN_NAME) : persist;
}
var DURABLE_OBJECTS_PLUGIN = {
  options: DurableObjectsOptionsSchema,
  sharedOptions: DurableObjectsSharedOptionsSchema,
  getBindings(options) {
    return Object.entries(options.durableObjects ?? {}).map(
      ([name, klass]) => {
        const { className, serviceName } = normaliseDurableObject(klass);
        return {
          name,
          durableObjectNamespace: { className, serviceName }
        };
      }
    );
  },
  getNodeBindings(options) {
    const objects = Object.keys(options.durableObjects ?? {});
    return Object.fromEntries(objects.map((name) => [name, kProxyNodeBinding]));
  },
  async getServices({ sharedOptions, tmpPath, durableObjectClassNames }) {
    let hasDurableObjects = false;
    for (const classNames of durableObjectClassNames.values()) {
      if (classNames.size > 0) {
        hasDurableObjects = true;
        break;
      }
    }
    if (!hasDurableObjects)
      return;
    const storagePath = normaliseDurableObjectStoragePath(
      tmpPath,
      sharedOptions.durableObjectsPersist
    );
    await import_promises5.default.mkdir(storagePath, { recursive: true });
    return [
      {
        // Note this service will be de-duped by name if multiple Workers create
        // it. Each Worker will have the same `sharedOptions` though, so this
        // isn't a problem.
        name: DURABLE_OBJECTS_STORAGE_SERVICE_NAME,
        disk: { path: storagePath, writable: true }
      }
    ];
  }
};

// packages/miniflare/src/plugins/core/constants.ts
var CORE_PLUGIN_NAME = "core";
var SERVICE_ENTRY = `${CORE_PLUGIN_NAME}:entry`;
var SERVICE_USER_PREFIX = `${CORE_PLUGIN_NAME}:user`;
var SERVICE_BUILTIN_PREFIX = `${CORE_PLUGIN_NAME}:builtin`;
var SERVICE_CUSTOM_PREFIX = `${CORE_PLUGIN_NAME}:custom`;
function getUserServiceName(workerName = "") {
  return `${SERVICE_USER_PREFIX}:${workerName}`;
}
var CUSTOM_SERVICE_KNOWN_OUTBOUND = "outbound";
function getBuiltinServiceName(workerIndex, kind, bindingName) {
  return `${SERVICE_BUILTIN_PREFIX}:${workerIndex}:${kind}${bindingName}`;
}
function getCustomServiceName(workerIndex, kind, bindingName) {
  return `${SERVICE_CUSTOM_PREFIX}:${workerIndex}:${kind}${bindingName}`;
}

// packages/miniflare/src/plugins/core/modules.ts
var import_assert12 = __toESM(require("assert"));
var import_fs3 = require("fs");
var import_module = require("module");
var import_path9 = __toESM(require("path"));
var import_util = require("util");
var import_acorn = require("acorn");
var import_acorn_walk = require("acorn-walk");
var import_colors4 = require("kleur/colors");
var import_zod10 = require("zod");
var SUGGEST_BUNDLE = "If you're trying to import an npm package, you'll need to bundle your Worker first.";
var SUGGEST_NODE = "If you're trying to import a Node.js built-in module, or an npm package that uses Node.js built-ins, you'll either need to:\n- Bundle your Worker, configuring your bundler to polyfill Node.js built-ins\n- Configure your bundler to load Workers-compatible builds by changing the main fields/conditions\n- Enable the `nodejs_compat` compatibility flag and use the `NodeJsCompatModule` module type\n- Find an alternative package that doesn't require Node.js built-ins";
var builtinModulesWithPrefix = import_module.builtinModules.concat(
  import_module.builtinModules.map((module2) => `node:${module2}`)
);
function buildStringScriptPath(workerIndex) {
  return `<script:${workerIndex}>`;
}
var stringScriptRegexp = /^<script:(\d+)>$/;
function maybeGetStringScriptPathIndex(scriptPath) {
  const match = stringScriptRegexp.exec(scriptPath);
  return match === null ? void 0 : parseInt(match[1]);
}
var ModuleRuleTypeSchema = import_zod10.z.enum([
  "ESModule",
  "CommonJS",
  "NodeJsCompatModule",
  "Text",
  "Data",
  "CompiledWasm"
]);
var ModuleRuleSchema = import_zod10.z.object({
  type: ModuleRuleTypeSchema,
  include: import_zod10.z.string().array(),
  fallthrough: import_zod10.z.boolean().optional()
});
var ModuleDefinitionSchema = import_zod10.z.object({
  type: ModuleRuleTypeSchema,
  path: import_zod10.z.string(),
  contents: import_zod10.z.string().or(import_zod10.z.instanceof(Uint8Array)).optional()
});
var SourceOptionsSchema = import_zod10.z.union([
  import_zod10.z.object({
    // Manually defined modules
    // (used by Wrangler which has its own module collection code)
    modules: import_zod10.z.array(ModuleDefinitionSchema),
    // `modules` "name"s will be their paths relative to this value.
    // This ensures file paths in stack traces are correct.
    modulesRoot: import_zod10.z.string().optional()
  }),
  import_zod10.z.object({
    script: import_zod10.z.string(),
    // Optional script path for resolving modules, and stack traces file names
    scriptPath: import_zod10.z.string().optional(),
    // Automatically collect modules by parsing `script` if `true`, or treat as
    // service-worker if `false`
    modules: import_zod10.z.boolean().optional(),
    // How to interpret automatically collected modules
    modulesRules: import_zod10.z.array(ModuleRuleSchema).optional(),
    // `modules` "name"s will be their paths relative to this value.
    // This ensures file paths in stack traces are correct.
    modulesRoot: import_zod10.z.string().optional()
  }),
  import_zod10.z.object({
    scriptPath: import_zod10.z.string(),
    // Automatically collect modules by parsing `scriptPath` if `true`, or treat
    // as service-worker if `false`
    modules: import_zod10.z.boolean().optional(),
    // How to interpret automatically collected modules
    modulesRules: import_zod10.z.array(ModuleRuleSchema).optional(),
    // `modules` "name"s will be their paths relative to this value.
    // This ensures file paths in stack traces are correct.
    modulesRoot: import_zod10.z.string().optional()
  })
]);
var DEFAULT_MODULE_RULES = [
  { type: "ESModule", include: ["**/*.mjs"] },
  { type: "CommonJS", include: ["**/*.js", "**/*.cjs"] }
];
function compileModuleRules(rules) {
  const compiledRules = [];
  const finalisedTypes = /* @__PURE__ */ new Set();
  for (const rule of [...rules ?? [], ...DEFAULT_MODULE_RULES]) {
    if (finalisedTypes.has(rule.type))
      continue;
    compiledRules.push({
      type: rule.type,
      include: globsToRegExps(rule.include)
    });
    if (!rule.fallthrough)
      finalisedTypes.add(rule.type);
  }
  return compiledRules;
}
function moduleName(modulesRoot, modulePath) {
  const name = import_path9.default.relative(modulesRoot, modulePath);
  return import_path9.default.sep === "\\" ? name.replaceAll("\\", "/") : name;
}
function getResolveErrorPrefix(referencingPath) {
  const relative = import_path9.default.relative("", referencingPath);
  return `Unable to resolve "${relative}" dependency`;
}
var ModuleLocator = class {
  constructor(sourceMapRegistry, modulesRoot, additionalModuleNames, rules, compatibilityFlags) {
    this.sourceMapRegistry = sourceMapRegistry;
    this.modulesRoot = modulesRoot;
    this.additionalModuleNames = additionalModuleNames;
    this.#compiledRules = compileModuleRules(rules);
    this.#nodejsCompat = compatibilityFlags?.includes("nodejs_compat") ?? false;
  }
  #compiledRules;
  #nodejsCompat;
  #visitedPaths = /* @__PURE__ */ new Set();
  modules = [];
  visitEntrypoint(code, modulePath) {
    modulePath = import_path9.default.resolve(modulePath);
    if (this.#visitedPaths.has(modulePath))
      return;
    this.#visitedPaths.add(modulePath);
    this.#visitJavaScriptModule(code, modulePath, "ESModule");
  }
  #visitJavaScriptModule(code, modulePath, type) {
    const name = moduleName(this.modulesRoot, modulePath);
    const module2 = createJavaScriptModule(
      this.sourceMapRegistry,
      code,
      name,
      modulePath,
      type
    );
    this.modules.push(module2);
    const isESM = type === "ESModule";
    let root;
    try {
      root = (0, import_acorn.parse)(code, {
        ecmaVersion: "latest",
        sourceType: isESM ? "module" : "script",
        locations: true
      });
    } catch (e) {
      let loc = "";
      if (e.loc?.line !== void 0) {
        loc += `:${e.loc.line}`;
        if (e.loc.column !== void 0)
          loc += `:${e.loc.column}`;
      }
      throw new MiniflareCoreError(
        "ERR_MODULE_PARSE",
        `Unable to parse "${name}": ${e.message ?? e}
    at ${modulePath}${loc}`
      );
    }
    const visitors = {
      ImportDeclaration: (node) => {
        this.#visitModule(modulePath, name, type, node.source);
      },
      ExportNamedDeclaration: (node) => {
        if (node.source != null) {
          this.#visitModule(modulePath, name, type, node.source);
        }
      },
      ExportAllDeclaration: (node) => {
        this.#visitModule(modulePath, name, type, node.source);
      },
      ImportExpression: (node) => {
        this.#visitModule(modulePath, name, type, node.source);
      },
      CallExpression: isESM ? void 0 : (node) => {
        const argument = node.arguments[0];
        if (node.callee.type === "Identifier" && node.callee.name === "require" && argument !== void 0) {
          this.#visitModule(modulePath, name, type, argument);
        }
      }
    };
    (0, import_acorn_walk.simple)(root, visitors);
  }
  #visitModule(referencingPath, referencingName, referencingType, specExpression) {
    if (maybeGetStringScriptPathIndex(referencingName) !== void 0) {
      const prefix = getResolveErrorPrefix(referencingPath);
      throw new MiniflareCoreError(
        "ERR_MODULE_STRING_SCRIPT",
        `${prefix}: imports are unsupported in string \`script\` without defined \`scriptPath\``
      );
    }
    if (specExpression.type !== "Literal" || typeof specExpression.value !== "string") {
      const modules = this.modules.map((mod) => {
        const def = convertWorkerModule(mod);
        return `      { type: "${def.type}", path: "${def.path}" }`;
      });
      const modulesConfig = `  new Miniflare({
    ...,
    modules: [
${modules.join(",\n")},
      ...
    ]
  })`;
      const prefix = getResolveErrorPrefix(referencingPath);
      let message = `${prefix}: dynamic module specifiers are unsupported.
You must manually define your modules when constructing Miniflare:
${(0, import_colors4.dim)(modulesConfig)}`;
      if (specExpression.loc != null) {
        const { line, column } = specExpression.loc.start;
        message += `
    at ${referencingPath}:${line}:${column}`;
      }
      throw new MiniflareCoreError("ERR_MODULE_DYNAMIC_SPEC", message);
    }
    const spec = specExpression.value;
    const isNodeJsCompatModule = referencingType === "NodeJsCompatModule";
    if (this.#nodejsCompat && spec.startsWith("node:") || spec.startsWith("cloudflare:") || spec.startsWith("workerd:") || isNodeJsCompatModule && builtinModulesWithPrefix.includes(spec) || this.additionalModuleNames.includes(spec)) {
      return;
    }
    const identifier = import_path9.default.resolve(import_path9.default.dirname(referencingPath), spec);
    const name = moduleName(this.modulesRoot, identifier);
    if (this.#visitedPaths.has(identifier))
      return;
    this.#visitedPaths.add(identifier);
    const rule = this.#compiledRules.find(
      (rule2) => testRegExps(rule2.include, identifier)
    );
    if (rule === void 0) {
      const prefix = getResolveErrorPrefix(referencingPath);
      const isBuiltin = builtinModulesWithPrefix.includes(spec);
      const suggestion = isBuiltin ? SUGGEST_NODE : SUGGEST_BUNDLE;
      throw new MiniflareCoreError(
        "ERR_MODULE_RULE",
        `${prefix} "${spec}": no matching module rules.
${suggestion}`
      );
    }
    const data = (0, import_fs3.readFileSync)(identifier);
    switch (rule.type) {
      case "ESModule":
      case "CommonJS":
      case "NodeJsCompatModule":
        const code = data.toString("utf8");
        this.#visitJavaScriptModule(code, identifier, rule.type);
        break;
      case "Text":
        this.modules.push({ name, text: data.toString("utf8") });
        break;
      case "Data":
        this.modules.push({ name, data });
        break;
      case "CompiledWasm":
        this.modules.push({ name, wasm: data });
        break;
      default:
        const exhaustive = rule.type;
        import_assert12.default.fail(`Unreachable: ${exhaustive} modules are unsupported`);
    }
  }
};
function createJavaScriptModule(sourceMapRegistry, code, name, modulePath, type) {
  code = sourceMapRegistry.register(code, modulePath);
  if (type === "ESModule") {
    return { name, esModule: code };
  } else if (type === "CommonJS") {
    return { name, commonJsModule: code };
  } else if (type === "NodeJsCompatModule") {
    return { name, nodeJsCompatModule: code };
  }
  const exhaustive = type;
  import_assert12.default.fail(`Unreachable: ${exhaustive} JavaScript modules are unsupported`);
}
var encoder2 = new import_util.TextEncoder();
var decoder = new import_util.TextDecoder();
function contentsToString(contents) {
  return typeof contents === "string" ? contents : decoder.decode(contents);
}
function contentsToArray(contents) {
  return typeof contents === "string" ? encoder2.encode(contents) : contents;
}
function convertModuleDefinition(sourceMapRegistry, modulesRoot, def) {
  const name = moduleName(modulesRoot, def.path);
  const contents = def.contents ?? (0, import_fs3.readFileSync)(def.path);
  switch (def.type) {
    case "ESModule":
    case "CommonJS":
    case "NodeJsCompatModule":
      return createJavaScriptModule(
        sourceMapRegistry,
        contentsToString(contents),
        name,
        def.path,
        def.type
      );
    case "Text":
      return { name, text: contentsToString(contents) };
    case "Data":
      return { name, data: contentsToArray(contents) };
    case "CompiledWasm":
      return { name, wasm: contentsToArray(contents) };
    default:
      const exhaustive = def.type;
      import_assert12.default.fail(`Unreachable: ${exhaustive} modules are unsupported`);
  }
}
function convertWorkerModule(mod) {
  const path14 = mod.name;
  (0, import_assert12.default)(path14 !== void 0);
  const m = mod;
  if ("esModule" in m)
    return { path: path14, type: "ESModule" };
  else if ("commonJsModule" in m)
    return { path: path14, type: "CommonJS" };
  else if ("nodeJsCompatModule" in m)
    return { path: path14, type: "NodeJsCompatModule" };
  else if ("text" in m)
    return { path: path14, type: "Text" };
  else if ("data" in m)
    return { path: path14, type: "Data" };
  else if ("wasm" in m)
    return { path: path14, type: "CompiledWasm" };
  (0, import_assert12.default)(!("json" in m), "Unreachable: json modules aren't generated");
  const exhaustive = m;
  import_assert12.default.fail(
    `Unreachable: [${Object.keys(exhaustive).join(
      ", "
    )}] modules are unsupported`
  );
}

// packages/miniflare/src/plugins/core/services.ts
var import_zod11 = require("zod");
var HttpOptionsHeaderSchema = import_zod11.z.object({
  name: import_zod11.z.string(),
  // name should be required
  value: import_zod11.z.ostring()
  // If omitted, the header will be removed
});
var HttpOptionsSchema = import_zod11.z.object({
  style: import_zod11.z.nativeEnum(import_workerd_capnp.HttpOptions_Style).optional(),
  forwardedProtoHeader: import_zod11.z.ostring(),
  cfBlobHeader: import_zod11.z.ostring(),
  injectRequestHeaders: HttpOptionsHeaderSchema.array().optional(),
  injectResponseHeaders: HttpOptionsHeaderSchema.array().optional()
});
var TlsOptionsKeypairSchema = import_zod11.z.object({
  privateKey: import_zod11.z.ostring(),
  certificateChain: import_zod11.z.ostring()
});
var TlsOptionsSchema = import_zod11.z.object({
  keypair: TlsOptionsKeypairSchema.optional(),
  requireClientCerts: import_zod11.z.oboolean(),
  trustBrowserCas: import_zod11.z.oboolean(),
  trustedCertificates: import_zod11.z.string().array().optional(),
  minVersion: import_zod11.z.nativeEnum(import_workerd_capnp.TlsOptions_Version).optional(),
  cipherList: import_zod11.z.ostring()
});
var NetworkSchema = import_zod11.z.object({
  allow: import_zod11.z.string().array().optional(),
  deny: import_zod11.z.string().array().optional(),
  tlsOptions: TlsOptionsSchema.optional()
});
var ExternalServerSchema = import_zod11.z.intersection(
  import_zod11.z.object({ address: import_zod11.z.string() }),
  // address should be required
  import_zod11.z.union([
    import_zod11.z.object({ http: import_zod11.z.optional(HttpOptionsSchema) }),
    import_zod11.z.object({
      https: import_zod11.z.optional(
        import_zod11.z.object({
          options: HttpOptionsSchema.optional(),
          tlsOptions: TlsOptionsSchema.optional(),
          certificateHost: import_zod11.z.ostring()
        })
      )
    })
  ])
);
var DiskDirectorySchema = import_zod11.z.object({
  path: import_zod11.z.string(),
  // path should be required
  writable: import_zod11.z.oboolean()
});
var ServiceFetchSchema = import_zod11.z.function().args(import_zod11.z.instanceof(Request)).returns(zAwaitable(import_zod11.z.instanceof(Response)));
var ServiceDesignatorSchema = import_zod11.z.union([
  import_zod11.z.string(),
  import_zod11.z.object({ network: NetworkSchema }),
  import_zod11.z.object({ external: ExternalServerSchema }),
  import_zod11.z.object({ disk: DiskDirectorySchema }),
  ServiceFetchSchema
]);

// packages/miniflare/src/plugins/core/errors/index.ts
var import_fs4 = __toESM(require("fs"));
var import_path10 = __toESM(require("path"));
var import_zod12 = require("zod");

// packages/miniflare/src/plugins/core/errors/sourcemap.ts
var import_assert13 = __toESM(require("assert"));

// packages/miniflare/src/plugins/core/errors/callsite.ts
function parseStack(stack) {
  return stack.split("\n").slice(1).map(parseCallSite).filter((site) => site !== void 0);
}
function parseCallSite(line) {
  const lineMatch = line.match(
    /at (?:(.+?)\s+\()?(?:(.+?):(\d+)(?::(\d+))?|([^)]+))\)?/
  );
  if (!lineMatch) {
    return;
  }
  let object = null;
  let method = null;
  let functionName = null;
  let typeName = null;
  let methodName = null;
  const isNative = lineMatch[5] === "native";
  if (lineMatch[1]) {
    functionName = lineMatch[1];
    let methodStart = functionName.lastIndexOf(".");
    if (functionName[methodStart - 1] == ".")
      methodStart--;
    if (methodStart > 0) {
      object = functionName.substring(0, methodStart);
      method = functionName.substring(methodStart + 1);
      const objectEnd = object.indexOf(".Module");
      if (objectEnd > 0) {
        functionName = functionName.substring(objectEnd + 1);
        object = object.substring(0, objectEnd);
      }
    }
  }
  if (method) {
    typeName = object;
    methodName = method;
  }
  if (method === "<anonymous>") {
    methodName = null;
    functionName = null;
  }
  return new CallSite({
    typeName,
    functionName,
    methodName,
    fileName: lineMatch[2] || null,
    lineNumber: parseInt(lineMatch[3]) || null,
    columnNumber: parseInt(lineMatch[4]) || null,
    native: isNative
  });
}
var CallSite = class {
  constructor(opts) {
    this.opts = opts;
  }
  getThis() {
    return null;
  }
  getTypeName() {
    return this.opts.typeName;
  }
  // eslint-disable-next-line @typescript-eslint/ban-types
  getFunction() {
    return void 0;
  }
  getFunctionName() {
    return this.opts.functionName;
  }
  getMethodName() {
    return this.opts.methodName;
  }
  getFileName() {
    return this.opts.fileName;
  }
  getScriptNameOrSourceURL() {
    return this.opts.fileName;
  }
  getLineNumber() {
    return this.opts.lineNumber;
  }
  getColumnNumber() {
    return this.opts.columnNumber;
  }
  getEvalOrigin() {
    return void 0;
  }
  isToplevel() {
    return false;
  }
  isEval() {
    return false;
  }
  isNative() {
    return this.opts.native;
  }
  isConstructor() {
    return false;
  }
  isAsync() {
    return false;
  }
  isPromiseAll() {
    return false;
  }
  isPromiseAny() {
    return false;
  }
  getPromiseIndex() {
    return null;
  }
};

// packages/miniflare/src/plugins/core/errors/sourcemap.ts
var sourceMapInstallBaseOptions = {
  environment: "node",
  // Don't add Node `uncaughtException` handler
  handleUncaughtExceptions: false,
  // Don't hook Node `require` function
  hookRequire: false,
  // Make sure we're using fresh copies of files (i.e. between `setOptions()`)
  emptyCacheBetweenOperations: true,
  // Always remove existing retrievers when calling `install()`, we should be
  // specifying them each time we want to source map
  overrideRetrieveFile: true,
  overrideRetrieveSourceMap: true
};
var sourceMapper;
function getSourceMapper() {
  if (sourceMapper !== void 0)
    return sourceMapper;
  const originalSupport = require.cache["source-map-support"];
  delete require.cache["source-map-support"];
  const support = require("source-map-support");
  require.cache["source-map-support"] = originalSupport;
  const originalPrepareStackTrace = Error.prepareStackTrace;
  support.install(sourceMapInstallBaseOptions);
  const prepareStackTrace = Error.prepareStackTrace;
  (0, import_assert13.default)(prepareStackTrace !== void 0);
  Error.prepareStackTrace = originalPrepareStackTrace;
  sourceMapper = (retrieveSourceMap, error) => {
    support.install({
      ...sourceMapInstallBaseOptions,
      retrieveFile(file) {
        import_assert13.default.fail(`Unexpected retrieveFile(${JSON.stringify(file)}) call`);
      },
      retrieveSourceMap
    });
    const callSites = parseStack(error.stack ?? "");
    return prepareStackTrace(error, callSites);
  };
  return sourceMapper;
}

// packages/miniflare/src/plugins/core/errors/index.ts
function maybeGetDiskFile(filePath) {
  try {
    const contents = import_fs4.default.readFileSync(filePath, "utf8");
    return { path: filePath, contents };
  } catch (e) {
    if (e.code !== "ENOENT")
      throw e;
  }
}
function maybeGetFile(workerSrcOpts, file) {
  const filePath = import_path10.default.resolve(file);
  for (const srcOpts of workerSrcOpts) {
    if (Array.isArray(srcOpts.modules)) {
      const modulesRoot = "modulesRoot" in srcOpts ? srcOpts.modulesRoot : void 0;
      const modulesRootedFilePath = modulesRoot === void 0 ? filePath : import_path10.default.resolve(modulesRoot, file);
      for (const module2 of srcOpts.modules) {
        if (import_path10.default.resolve(module2.path) === modulesRootedFilePath) {
          if (module2.contents === void 0) {
            return maybeGetDiskFile(modulesRootedFilePath);
          } else {
            return {
              path: modulesRootedFilePath,
              contents: contentsToString(module2.contents)
            };
          }
        }
      }
    }
  }
  for (const srcOpts of workerSrcOpts) {
    if ("scriptPath" in srcOpts && "script" in srcOpts && srcOpts.scriptPath !== void 0 && srcOpts.script !== void 0 && import_path10.default.resolve(srcOpts.scriptPath) === filePath) {
      return { path: filePath, contents: srcOpts.script };
    }
  }
  const workerIndex = maybeGetStringScriptPathIndex(file);
  if (workerIndex !== void 0) {
    const srcOpts = workerSrcOpts[workerIndex];
    if ("script" in srcOpts && srcOpts.script !== void 0) {
      return { contents: srcOpts.script };
    }
  }
  for (const srcOpts of workerSrcOpts) {
    if (file === getUserServiceName(srcOpts.name) && (srcOpts.modules === void 0 || srcOpts.modules === false)) {
      if ("script" in srcOpts && srcOpts.script !== void 0) {
        return {
          path: srcOpts.scriptPath === void 0 ? void 0 : import_path10.default.resolve(srcOpts.scriptPath),
          contents: srcOpts.script
        };
      } else if (srcOpts.scriptPath !== void 0) {
        return maybeGetDiskFile(import_path10.default.resolve(srcOpts.scriptPath));
      }
    }
  }
  return maybeGetDiskFile(filePath);
}
function getSourceMappedStack(workerSrcOpts, error) {
  function retrieveSourceMap(file) {
    const sourceFile = maybeGetFile(workerSrcOpts, file);
    if (sourceFile?.path === void 0)
      return null;
    const sourceMapRegexp = /# sourceMappingURL=(.+)/g;
    const matches = [...sourceFile.contents.matchAll(sourceMapRegexp)];
    if (matches.length === 0)
      return null;
    const sourceMapMatch = matches[matches.length - 1];
    const root = import_path10.default.dirname(sourceFile.path);
    const sourceMapPath = import_path10.default.resolve(root, sourceMapMatch[1]);
    const sourceMapFile = maybeGetDiskFile(sourceMapPath);
    if (sourceMapFile === void 0)
      return null;
    return { map: sourceMapFile.contents, url: sourceMapFile.path };
  }
  return getSourceMapper()(retrieveSourceMap, error);
}
var JsonErrorSchema = import_zod12.z.lazy(
  () => import_zod12.z.object({
    message: import_zod12.z.string().optional(),
    name: import_zod12.z.string().optional(),
    stack: import_zod12.z.string().optional(),
    cause: JsonErrorSchema.optional()
  })
);
var ALLOWED_ERROR_SUBCLASS_CONSTRUCTORS = [
  EvalError,
  RangeError,
  ReferenceError,
  SyntaxError,
  TypeError,
  URIError
];
function reviveError(workerSrcOpts, jsonError) {
  let cause;
  if (jsonError.cause !== void 0) {
    cause = reviveError(workerSrcOpts, jsonError.cause);
  }
  let ctor = Error;
  if (jsonError.name !== void 0 && jsonError.name in globalThis) {
    const maybeCtor = globalThis[jsonError.name];
    if (ALLOWED_ERROR_SUBCLASS_CONSTRUCTORS.includes(maybeCtor)) {
      ctor = maybeCtor;
    }
  }
  const error = new ctor(jsonError.message, { cause });
  if (jsonError.name !== void 0)
    error.name = jsonError.name;
  error.stack = jsonError.stack;
  error.stack = getSourceMappedStack(workerSrcOpts, error);
  return error;
}
async function handlePrettyErrorRequest(log, workerSrcOpts, request) {
  const caught = JsonErrorSchema.parse(await request.json());
  const error = reviveError(workerSrcOpts, caught);
  log.error(error);
  const Youch = require("youch");
  const youch = new Youch(error.cause ?? error, {
    url: request.url,
    method: request.method,
    headers: Object.fromEntries(request.headers)
  });
  youch.addLink(() => {
    return [
      '<a href="https://developers.cloudflare.com/workers/" target="_blank" style="text-decoration:none">\u{1F4DA} Workers Docs</a>',
      '<a href="https://discord.gg/cloudflaredev" target="_blank" style="text-decoration:none">\u{1F4AC} Workers Discord</a>'
    ].join("");
  });
  return new Response(await youch.toHTML(), {
    status: 500,
    headers: { "Content-Type": "text/html;charset=utf-8" }
  });
}

// packages/miniflare/src/plugins/core/proxy/client.ts
var import_assert15 = __toESM(require("assert"));
var import_web8 = require("stream/web");
var import_util2 = __toESM(require("util"));
var import_undici6 = require("undici");

// packages/miniflare/src/plugins/core/proxy/fetch-sync.ts
var import_assert14 = __toESM(require("assert"));
var import_web6 = require("stream/web");
var import_worker_threads = require("worker_threads");
var DECODER = new TextDecoder();
var WORKER_SCRIPT = (
  /* javascript */
  `
const { workerData } = require("worker_threads");
const { fetch } = require("undici");

// Not using parentPort here so we can call receiveMessageOnPort() in host
const { notifyHandle, port } = workerData;

port.addEventListener("message", async (event) => {
  const { id, method, url, headers, body } = event.data;
  headers["${CoreHeaders.OP_SYNC}"] = "true";
  try {
    // body cannot be a ReadableStream, so no need to specify duplex
    const response = await fetch(url, { method, headers, body });
    const responseBody = response.headers.get("${CoreHeaders.OP_RESULT_TYPE}") === "ReadableStream"
      ? response.body
      : await response.arrayBuffer();
    const transferList = responseBody === null ? undefined : [responseBody];
    port.postMessage(
      {
        id,
        response: {
          status: response.status,
          headers: Object.fromEntries(response.headers),
          body: responseBody,
        }
      },
      transferList
    );
  } catch (error) {
    try {
      port.postMessage({ id, error });
    } catch {
      // If error failed to serialise, post simplified version
      port.postMessage({ id, error: new Error(String(error)) });
    }
  }
  Atomics.store(notifyHandle, /* index */ 0, /* value */ 1);
  Atomics.notify(notifyHandle, /* index */ 0);
});
`
);
var SynchronousFetcher = class {
  #channel;
  #notifyHandle;
  #worker;
  #nextId = 0;
  constructor() {
    this.#channel = new import_worker_threads.MessageChannel();
    this.#notifyHandle = new Int32Array(new SharedArrayBuffer(4));
  }
  #ensureWorker() {
    if (this.#worker !== void 0)
      return;
    this.#worker = new import_worker_threads.Worker(WORKER_SCRIPT, {
      eval: true,
      workerData: {
        notifyHandle: this.#notifyHandle,
        port: this.#channel.port2
      },
      transferList: [this.#channel.port2]
    });
  }
  fetch(url, init) {
    this.#ensureWorker();
    Atomics.store(
      this.#notifyHandle,
      /* index */
      0,
      /* value */
      0
    );
    const id = this.#nextId++;
    this.#channel.port1.postMessage({
      id,
      method: init.method,
      url: url.toString(),
      headers: init.headers,
      body: init.body
    });
    Atomics.wait(
      this.#notifyHandle,
      /* index */
      0,
      /* value */
      0
    );
    const message = (0, import_worker_threads.receiveMessageOnPort)(
      this.#channel.port1
    )?.message;
    (0, import_assert14.default)(message?.id === id);
    if ("response" in message) {
      const { status, headers: rawHeaders, body } = message.response;
      const headers = new import_undici8.Headers(rawHeaders);
      const stack = headers.get(CoreHeaders.ERROR_STACK);
      if (status === 500 && stack !== null && body !== null) {
        (0, import_assert14.default)(!(body instanceof import_web6.ReadableStream));
        const caught = JsonErrorSchema.parse(JSON.parse(DECODER.decode(body)));
        throw reviveError([], caught);
      }
      return { status, headers, body };
    } else {
      throw message.error;
    }
  }
  async dispose() {
    await this.#worker?.terminate();
  }
};

// packages/miniflare/src/plugins/core/proxy/types.ts
var import_buffer = require("buffer");
var import_consumers2 = require("stream/consumers");
var import_web7 = require("stream/web");
var import_undici5 = require("undici");
var NODE_PLATFORM_IMPL = {
  // Node's implementation of these classes don't quite match Workers',
  // but they're close enough for us
  Blob: import_buffer.Blob,
  File: import_undici5.File,
  Headers: import_undici5.Headers,
  Request,
  Response,
  isReadableStream(value) {
    return value instanceof import_web7.ReadableStream;
  },
  bufferReadableStream(stream) {
    return (0, import_consumers2.arrayBuffer)(stream);
  },
  unbufferReadableStream(buffer) {
    return new import_buffer.Blob([new Uint8Array(buffer)]).stream();
  }
};

// packages/miniflare/src/plugins/core/proxy/client.ts
var kAddress = Symbol("kAddress");
var kName = Symbol("kName");
function isNativeTarget(value) {
  return typeof value === "object" && value !== null && kAddress in value;
}
var TARGET_GLOBAL = {
  [kAddress]: ProxyAddresses.GLOBAL,
  [kName]: "global"
};
var TARGET_ENV = {
  [kAddress]: ProxyAddresses.ENV,
  [kName]: "env"
};
var reducers = {
  ...structuredSerializableReducers,
  ...createHTTPReducers(NODE_PLATFORM_IMPL),
  Native(value) {
    if (isNativeTarget(value))
      return [value[kAddress], value[kName]];
  }
};
var revivers = {
  ...structuredSerializableRevivers,
  ...createHTTPRevivers(NODE_PLATFORM_IMPL)
  // `Native` reviver depends on `ProxyStubHandler` methods
};
var ProxyClient = class {
  #bridge;
  constructor(runtimeEntryURL, dispatchFetch) {
    this.#bridge = new ProxyClientBridge(runtimeEntryURL, dispatchFetch);
  }
  // Lazily initialise proxies as required
  #globalProxy;
  #envProxy;
  get global() {
    return this.#globalProxy ??= this.#bridge.getProxy(TARGET_GLOBAL);
  }
  get env() {
    return this.#envProxy ??= this.#bridge.getProxy(TARGET_ENV);
  }
  poisonProxies(runtimeEntryURL) {
    this.#bridge.poisonProxies(runtimeEntryURL);
    this.#globalProxy = void 0;
    this.#envProxy = void 0;
  }
  dispose() {
    return this.#bridge.dispose();
  }
};
var ProxyClientBridge = class {
  constructor(url, dispatchFetch) {
    this.url = url;
    this.dispatchFetch = dispatchFetch;
    this.#finalizationRegistry = new FinalizationRegistry(this.#finalizeProxy);
  }
  // Each proxy stub is initialised with the version stored here. Whenever
  // `poisonProxies()` is called, this version is incremented. Before the
  // proxy makes any request to `workerd`, it checks the version number here
  // matches its own internal version, and throws if not.
  #version = 0;
  // Whenever the `ProxyServer` returns a native target, it adds a strong
  // reference to the "heap" in the singleton object. This prevents the object
  // being garbage collected. To solve this, we register the native target
  // proxies on the client in a `FinalizationRegistry`. When the proxies get
  // garbage collected, we let the `ProxyServer` know it can release the strong
  // "heap" reference, as we'll never be able to access it again. Importantly,
  // we need to unregister all proxies from the registry when we poison them,
  // as the references will be invalid, and a new object with the same address
  // may be added to the "heap".
  #finalizationRegistry;
  sync = new SynchronousFetcher();
  get version() {
    return this.#version;
  }
  #finalizeProxy = async (held) => {
    if (held.version !== this.#version)
      return;
    try {
      await this.dispatchFetch(this.url, {
        method: "DELETE",
        headers: {
          [CoreHeaders.OP]: ProxyOps.FREE,
          [CoreHeaders.OP_TARGET]: held.address.toString()
        }
      });
    } catch {
    }
  };
  getProxy(target) {
    const handler = new ProxyStubHandler(this, target);
    const proxy = new Proxy(
      { [import_util2.default.inspect.custom]: handler.inspect },
      handler
    );
    const held = {
      address: target[kAddress],
      version: this.#version
    };
    this.#finalizationRegistry.register(proxy, held, this);
    return proxy;
  }
  poisonProxies(url) {
    this.#version++;
    if (url !== void 0)
      this.url = url;
    this.#finalizationRegistry.unregister(this);
  }
  dispose() {
    this.poisonProxies();
    return this.sync.dispose();
  }
};
var ProxyStubHandler = class {
  constructor(bridge, target) {
    this.bridge = bridge;
    this.target = target;
    this.#version = bridge.version;
    this.#stringifiedTarget = stringify(this.target, reducers);
  }
  #version;
  #stringifiedTarget;
  #known = /* @__PURE__ */ new Map();
  revivers = {
    ...revivers,
    Native: (value) => {
      (0, import_assert15.default)(Array.isArray(value));
      const [address, name] = value;
      (0, import_assert15.default)(typeof address === "number");
      (0, import_assert15.default)(typeof name === "string");
      const target = { [kAddress]: address, [kName]: name };
      if (name === "Promise") {
        const resPromise = this.bridge.dispatchFetch(this.bridge.url, {
          method: "POST",
          headers: {
            [CoreHeaders.OP]: ProxyOps.GET,
            // GET without key just gets target
            [CoreHeaders.OP_TARGET]: stringify(target, reducers)
          }
        });
        return this.#parseAsyncResponse(resPromise);
      } else {
        return this.bridge.getProxy(target);
      }
    }
  };
  get #poisoned() {
    return this.#version !== this.bridge.version;
  }
  #assertSafe() {
    if (this.#poisoned) {
      throw new Error(
        "Attempted to use poisoned stub. Stubs to runtime objects must be re-created after calling `Miniflare#setOptions()` or `Miniflare#dispose()`."
      );
    }
  }
  inspect = (depth, options) => {
    const details = { name: this.target[kName], poisoned: this.#poisoned };
    return `ProxyStub ${import_util2.default.inspect(details, options)}`;
  };
  #maybeThrow(res, result, caller) {
    if (res.status === 500) {
      if (typeof result === "object" && result !== null) {
        Error.captureStackTrace(result, caller);
      }
      throw result;
    } else {
      (0, import_assert15.default)(res.status === 200);
      return result;
    }
  }
  async #parseAsyncResponse(resPromise) {
    const res = await resPromise;
    const typeHeader = res.headers.get(CoreHeaders.OP_RESULT_TYPE);
    if (typeHeader === "Promise, ReadableStream")
      return res.body;
    (0, import_assert15.default)(typeHeader === "Promise");
    let stringifiedResult;
    let unbufferedStream;
    const stringifiedSizeHeader = res.headers.get(
      CoreHeaders.OP_STRINGIFIED_SIZE
    );
    if (stringifiedSizeHeader === null) {
      stringifiedResult = await res.text();
    } else {
      const stringifiedSize = parseInt(stringifiedSizeHeader);
      (0, import_assert15.default)(!Number.isNaN(stringifiedSize));
      (0, import_assert15.default)(res.body !== null);
      const [buffer, rest] = await readPrefix(res.body, stringifiedSize);
      stringifiedResult = buffer.toString();
      unbufferedStream = rest.pipeThrough(new import_web8.TransformStream());
    }
    const result = parseWithReadableStreams(
      NODE_PLATFORM_IMPL,
      { value: stringifiedResult, unbufferedStream },
      this.revivers
    );
    return this.#maybeThrow(res, result, this.#parseAsyncResponse);
  }
  #parseSyncResponse(syncRes, caller) {
    (0, import_assert15.default)(syncRes.body !== null);
    (0, import_assert15.default)(syncRes.headers.get(CoreHeaders.OP_STRINGIFIED_SIZE) === null);
    if (syncRes.body instanceof import_web8.ReadableStream)
      return syncRes.body;
    const stringifiedResult = DECODER.decode(syncRes.body);
    const result = parseWithReadableStreams(
      NODE_PLATFORM_IMPL,
      { value: stringifiedResult },
      this.revivers
    );
    return this.#maybeThrow(syncRes, result, caller);
  }
  get(_target, key, _receiver) {
    this.#assertSafe();
    if (key === kAddress)
      return this.target[kAddress];
    if (key === kName)
      return this.target[kName];
    if (typeof key === "symbol" || key === "then")
      return void 0;
    const maybeKnown = this.#known.get(key);
    if (maybeKnown !== void 0)
      return maybeKnown;
    const syncRes = this.bridge.sync.fetch(this.bridge.url, {
      method: "POST",
      headers: {
        [CoreHeaders.OP]: ProxyOps.GET,
        [CoreHeaders.OP_TARGET]: this.#stringifiedTarget,
        [CoreHeaders.OP_KEY]: key
      }
    });
    let result;
    if (syncRes.headers.get(CoreHeaders.OP_RESULT_TYPE) === "Function") {
      result = this.#createFunction(key);
    } else {
      result = this.#parseSyncResponse(syncRes, this.get);
    }
    if (
      // Optimisation: if this property is a function, we assume constant
      // prototypes of proxied objects, so it's never going to change
      typeof result === "function" || // Optimisation: if this property is a reference, we assume it's never
      // going to change. This allows us to reuse the known cache of nested
      // objects on multiple access (e.g. reusing `env["...<bucket>"]` proxy if
      // `getR2Bucket(<bucket>)` is called on the same bucket multiple times).
      isNativeTarget(result) || // Once a `ReadableStream` sent across proxy, we won't be able to read it
      // again in the server, so reuse the same stream for future accesses
      // (e.g. accessing `R2ObjectBody#body` multiple times)
      result instanceof import_web8.ReadableStream
    ) {
      this.#known.set(key, result);
    }
    return result;
  }
  has(target, key) {
    return this.get(target, key, void 0) !== void 0;
  }
  #createFunction(key) {
    let knownAsync = false;
    const func = {
      [key]: (...args) => {
        const result = this.#call(key, knownAsync, args, func);
        if (!knownAsync && result instanceof Promise)
          knownAsync = true;
        return result;
      }
    }[key];
    return func;
  }
  #call(key, knownAsync, args, caller) {
    this.#assertSafe();
    const targetName = this.target[kName];
    if (isFetcherFetch(targetName, key))
      return this.#fetcherFetchCall(args);
    const stringified = stringifyWithStreams(
      NODE_PLATFORM_IMPL,
      args,
      reducers,
      /* allowUnbufferedStream */
      true
    );
    if (knownAsync || // We assume every call with `ReadableStream`/`Blob` arguments is async.
    // Note that you can't consume `ReadableStream`/`Blob` synchronously: if
    // you tried a similar trick to `SynchronousFetcher`, blocking the main
    // thread with `Atomics.wait()` would prevent chunks being read. This
    // assumption doesn't hold for `Blob`s and `FormData#{append,set}()`, but
    // we should never expose proxies for those APIs to users.
    stringified instanceof Promise || // (instanceof Promise if buffered `ReadableStream`/`Blob`s)
    stringified.unbufferedStream !== void 0) {
      return this.#asyncCall(key, stringified);
    } else {
      const result = this.#syncCall(key, stringified.value, caller);
      if (isR2ObjectWriteHttpMetadata(targetName, key)) {
        const arg = args[0];
        (0, import_assert15.default)(arg instanceof import_undici6.Headers);
        (0, import_assert15.default)(result instanceof import_undici6.Headers);
        for (const [key2, value] of result)
          arg.set(key2, value);
        return;
      }
      return result;
    }
  }
  #syncCall(key, stringifiedValue, caller) {
    const argsSize = Buffer.byteLength(stringifiedValue).toString();
    const syncRes = this.bridge.sync.fetch(this.bridge.url, {
      method: "POST",
      headers: {
        [CoreHeaders.OP]: ProxyOps.CALL,
        [CoreHeaders.OP_TARGET]: this.#stringifiedTarget,
        [CoreHeaders.OP_KEY]: key,
        [CoreHeaders.OP_STRINGIFIED_SIZE]: argsSize,
        "Content-Length": argsSize
      },
      body: stringifiedValue
    });
    return this.#parseSyncResponse(syncRes, caller);
  }
  async #asyncCall(key, stringifiedAwaitable) {
    const stringified = await stringifiedAwaitable;
    let resPromise;
    if (stringified.unbufferedStream === void 0) {
      const argsSize = Buffer.byteLength(stringified.value).toString();
      resPromise = this.bridge.dispatchFetch(this.bridge.url, {
        method: "POST",
        headers: {
          [CoreHeaders.OP]: ProxyOps.CALL,
          [CoreHeaders.OP_TARGET]: this.#stringifiedTarget,
          [CoreHeaders.OP_KEY]: key,
          [CoreHeaders.OP_STRINGIFIED_SIZE]: argsSize,
          "Content-Length": argsSize
        },
        body: stringified.value
      });
    } else {
      const encodedArgs = Buffer.from(stringified.value);
      const argsSize = encodedArgs.byteLength.toString();
      const body = prefixStream(encodedArgs, stringified.unbufferedStream);
      resPromise = this.bridge.dispatchFetch(this.bridge.url, {
        method: "POST",
        headers: {
          [CoreHeaders.OP]: ProxyOps.CALL,
          [CoreHeaders.OP_TARGET]: this.#stringifiedTarget,
          [CoreHeaders.OP_KEY]: key,
          [CoreHeaders.OP_STRINGIFIED_SIZE]: argsSize
        },
        duplex: "half",
        body
      });
    }
    return this.#parseAsyncResponse(resPromise);
  }
  #fetcherFetchCall(args) {
    const request = new Request(...args);
    request.headers.set(CoreHeaders.OP, ProxyOps.CALL);
    request.headers.set(CoreHeaders.OP_TARGET, this.#stringifiedTarget);
    request.headers.set(CoreHeaders.OP_KEY, "fetch");
    return this.bridge.dispatchFetch(request);
  }
};

// packages/miniflare/src/plugins/core/index.ts
var trustedCertificates = process.platform === "win32" ? Array.from(import_tls.default.rootCertificates) : [];
if (process.env.NODE_EXTRA_CA_CERTS !== void 0) {
  try {
    const extra = (0, import_fs5.readFileSync)(process.env.NODE_EXTRA_CA_CERTS, "utf8");
    const pemBegin = "-----BEGIN";
    for (const cert of extra.split(pemBegin)) {
      if (cert.trim() !== "")
        trustedCertificates.push(pemBegin + cert);
    }
  } catch {
  }
}
var encoder3 = new import_util3.TextEncoder();
var numericCompare = new Intl.Collator(void 0, { numeric: true }).compare;
function createFetchMock() {
  return new import_undici7.MockAgent();
}
var CoreOptionsSchemaInput = import_zod13.z.intersection(
  SourceOptionsSchema,
  import_zod13.z.object({
    name: import_zod13.z.string().optional(),
    compatibilityDate: import_zod13.z.string().optional(),
    compatibilityFlags: import_zod13.z.string().array().optional(),
    routes: import_zod13.z.string().array().optional(),
    bindings: import_zod13.z.record(JsonSchema).optional(),
    wasmBindings: import_zod13.z.record(import_zod13.z.string()).optional(),
    textBlobBindings: import_zod13.z.record(import_zod13.z.string()).optional(),
    dataBlobBindings: import_zod13.z.record(import_zod13.z.string()).optional(),
    serviceBindings: import_zod13.z.record(ServiceDesignatorSchema).optional(),
    outboundService: ServiceDesignatorSchema.optional(),
    fetchMock: import_zod13.z.instanceof(import_undici7.MockAgent).optional(),
    unsafeEphemeralDurableObjects: import_zod13.z.boolean().optional()
  })
);
var CoreOptionsSchema = CoreOptionsSchemaInput.transform((value) => {
  const fetchMock = value.fetchMock;
  if (fetchMock !== void 0) {
    if (value.outboundService !== void 0) {
      throw new MiniflareCoreError(
        "ERR_MULTIPLE_OUTBOUNDS",
        "Only one of `outboundService` or `fetchMock` may be specified per worker"
      );
    }
    value.outboundService = (req) => fetch2(req, { dispatcher: fetchMock });
  }
  return value;
});
var CoreSharedOptionsSchema = import_zod13.z.object({
  host: import_zod13.z.string().optional(),
  port: import_zod13.z.number().optional(),
  https: import_zod13.z.boolean().optional(),
  httpsKey: import_zod13.z.string().optional(),
  httpsKeyPath: import_zod13.z.string().optional(),
  httpsCert: import_zod13.z.string().optional(),
  httpsCertPath: import_zod13.z.string().optional(),
  inspectorPort: import_zod13.z.number().optional(),
  verbose: import_zod13.z.boolean().optional(),
  log: import_zod13.z.instanceof(Log).optional(),
  timers: import_zod13.z.custom().optional(),
  upstream: import_zod13.z.string().optional(),
  // TODO: add back validation of cf object
  cf: import_zod13.z.union([import_zod13.z.boolean(), import_zod13.z.string(), import_zod13.z.record(import_zod13.z.any())]).optional(),
  liveReload: import_zod13.z.boolean().optional(),
  unsafeSourceMapIgnoreSourcePredicate: IgnoreSourcePredicateSchema.optional()
});
var CORE_PLUGIN_NAME2 = "core";
var LIVE_RELOAD_SCRIPT_TEMPLATE = (port) => `<script defer type="application/javascript">
(function () {
  // Miniflare Live Reload
  var url = new URL("/cdn-cgi/mf/reload", location.origin);
  url.protocol = url.protocol.replace("http", "ws");
  url.port = ${port};
  function reload() { location.reload(); }
  function connect(reconnected) {
    var ws = new WebSocket(url);
    if (reconnected) ws.onopen = reload;
    ws.onclose = function(e) {
      e.code === 1012 ? reload() : e.code === 1000 || e.code === 1001 || setTimeout(connect, 1000, true);
    }
  }
  connect();
})();
</script>`;
var SCRIPT_CUSTOM_SERVICE = `addEventListener("fetch", (event) => {
  const request = new Request(event.request);
  request.headers.set("${CoreHeaders.CUSTOM_SERVICE}", ${CoreBindings.TEXT_CUSTOM_SERVICE});
  request.headers.set("${CoreHeaders.ORIGINAL_URL}", request.url);
  event.respondWith(${CoreBindings.SERVICE_LOOPBACK}.fetch(request));
})`;
function getCustomServiceDesignator(workerIndex, kind, name, service) {
  let serviceName;
  if (typeof service === "function") {
    serviceName = getCustomServiceName(workerIndex, kind, name);
  } else if (typeof service === "object") {
    serviceName = getBuiltinServiceName(workerIndex, kind, name);
  } else {
    serviceName = getUserServiceName(service);
  }
  return { name: serviceName };
}
function maybeGetCustomServiceService(workerIndex, kind, name, service) {
  if (typeof service === "function") {
    return {
      name: getCustomServiceName(workerIndex, kind, name),
      worker: {
        serviceWorkerScript: SCRIPT_CUSTOM_SERVICE,
        compatibilityDate: "2022-09-01",
        bindings: [
          {
            name: CoreBindings.TEXT_CUSTOM_SERVICE,
            text: `${workerIndex}/${kind}${name}`
          },
          WORKER_BINDING_SERVICE_LOOPBACK
        ]
      }
    };
  } else if (typeof service === "object") {
    return {
      name: getBuiltinServiceName(workerIndex, kind, name),
      ...service
    };
  }
}
var FALLBACK_COMPATIBILITY_DATE = "2000-01-01";
function getCurrentCompatibilityDate() {
  const now = new Date().toISOString();
  return now.substring(0, now.indexOf("T"));
}
function validateCompatibilityDate(log, compatibilityDate) {
  if (numericCompare(compatibilityDate, getCurrentCompatibilityDate()) > 0) {
    throw new MiniflareCoreError(
      "ERR_FUTURE_COMPATIBILITY_DATE",
      `Compatibility date "${compatibilityDate}" is in the future and unsupported`
    );
  } else if (numericCompare(compatibilityDate, import_workerd2.compatibilityDate) > 0) {
    log.warn(
      [
        "The latest compatibility date supported by the installed Cloudflare Workers Runtime is ",
        (0, import_colors5.bold)(`"${import_workerd2.compatibilityDate}"`),
        ",\nbut you've requested ",
        (0, import_colors5.bold)(`"${compatibilityDate}"`),
        ". Falling back to ",
        (0, import_colors5.bold)(`"${import_workerd2.compatibilityDate}"`),
        "..."
      ].join("")
    );
    return import_workerd2.compatibilityDate;
  }
  return compatibilityDate;
}
var CORE_PLUGIN = {
  options: CoreOptionsSchema,
  sharedOptions: CoreSharedOptionsSchema,
  getBindings(options, workerIndex) {
    const bindings = [];
    if (options.bindings !== void 0) {
      bindings.push(
        ...Object.entries(options.bindings).map(([name, value]) => ({
          name,
          json: JSON.stringify(value)
        }))
      );
    }
    if (options.wasmBindings !== void 0) {
      bindings.push(
        ...Object.entries(options.wasmBindings).map(
          ([name, path14]) => import_promises6.default.readFile(path14).then((wasmModule) => ({ name, wasmModule }))
        )
      );
    }
    if (options.textBlobBindings !== void 0) {
      bindings.push(
        ...Object.entries(options.textBlobBindings).map(
          ([name, path14]) => import_promises6.default.readFile(path14, "utf8").then((text) => ({ name, text }))
        )
      );
    }
    if (options.dataBlobBindings !== void 0) {
      bindings.push(
        ...Object.entries(options.dataBlobBindings).map(
          ([name, path14]) => import_promises6.default.readFile(path14).then((data) => ({ name, data }))
        )
      );
    }
    if (options.serviceBindings !== void 0) {
      bindings.push(
        ...Object.entries(options.serviceBindings).map(([name, service]) => {
          return {
            name,
            service: getCustomServiceDesignator(
              workerIndex,
              "#" /* UNKNOWN */,
              name,
              service
            )
          };
        })
      );
    }
    return Promise.all(bindings);
  },
  async getNodeBindings(options) {
    const bindingEntries = [];
    if (options.bindings !== void 0) {
      bindingEntries.push(
        ...Object.entries(options.bindings).map(([name, value]) => [
          name,
          JSON.parse(JSON.stringify(value))
        ])
      );
    }
    if (options.wasmBindings !== void 0) {
      bindingEntries.push(
        ...Object.entries(options.wasmBindings).map(
          ([name, path14]) => import_promises6.default.readFile(path14).then((buffer) => [name, new WebAssembly.Module(buffer)])
        )
      );
    }
    if (options.textBlobBindings !== void 0) {
      bindingEntries.push(
        ...Object.entries(options.textBlobBindings).map(
          ([name, path14]) => import_promises6.default.readFile(path14, "utf8").then((text) => [name, text])
        )
      );
    }
    if (options.dataBlobBindings !== void 0) {
      bindingEntries.push(
        ...Object.entries(options.dataBlobBindings).map(
          ([name, path14]) => import_promises6.default.readFile(path14).then((buffer) => [name, viewToBuffer(buffer)])
        )
      );
    }
    if (options.serviceBindings !== void 0) {
      bindingEntries.push(
        ...Object.keys(options.serviceBindings).map((name) => [
          name,
          kProxyNodeBinding
        ])
      );
    }
    return Object.fromEntries(await Promise.all(bindingEntries));
  },
  async getServices({
    log,
    options,
    workerBindings,
    workerIndex,
    durableObjectClassNames,
    additionalModules,
    sourceMapRegistry
  }) {
    const additionalModuleNames = additionalModules.map(({ name: name2 }) => name2);
    const workerScript = getWorkerScript(
      sourceMapRegistry,
      options,
      workerIndex,
      additionalModuleNames
    );
    if ("modules" in workerScript) {
      const subDirs = new Set(
        workerScript.modules.map(({ name: name2 }) => import_path11.default.posix.dirname(name2))
      );
      subDirs.delete(".");
      for (const module2 of additionalModules) {
        workerScript.modules.push(module2);
        for (const subDir of subDirs) {
          const relativePath = import_path11.default.posix.relative(subDir, module2.name);
          const relativePathString = JSON.stringify(relativePath);
          workerScript.modules.push({
            name: import_path11.default.posix.join(subDir, module2.name),
            // TODO(someday): if we ever have additional modules without
            //  default exports, this may be a problem. For now, our only
            //  additional module is `__STATIC_CONTENT_MANIFEST` so it's fine.
            //  If needed, we could look for instances of `export default` or
            //  `as default` in the module's code as a heuristic.
            esModule: `export * from ${relativePathString}; export { default } from ${relativePathString};`
          });
        }
      }
    }
    const name = getUserServiceName(options.name);
    const classNames = durableObjectClassNames.get(name);
    const classNamesEntries = Array.from(classNames ?? []);
    const compatibilityDate = validateCompatibilityDate(
      log,
      options.compatibilityDate ?? FALLBACK_COMPATIBILITY_DATE
    );
    const services = [
      {
        name,
        worker: {
          ...workerScript,
          compatibilityDate,
          compatibilityFlags: options.compatibilityFlags,
          bindings: workerBindings,
          durableObjectNamespaces: classNamesEntries.map(
            ([className, unsafeUniqueKey]) => {
              return {
                className,
                // This `uniqueKey` will (among other things) be used as part of the
                // path when persisting to the file-system. `-` is invalid in
                // JavaScript class names, but safe on filesystems (incl. Windows).
                uniqueKey: unsafeUniqueKey ?? `${options.name ?? ""}-${className}`
              };
            }
          ),
          durableObjectStorage: classNamesEntries.length === 0 ? void 0 : options.unsafeEphemeralDurableObjects ? { inMemory: kVoid } : { localDisk: DURABLE_OBJECTS_STORAGE_SERVICE_NAME },
          globalOutbound: options.outboundService === void 0 ? void 0 : getCustomServiceDesignator(
            workerIndex,
            "$" /* KNOWN */,
            CUSTOM_SERVICE_KNOWN_OUTBOUND,
            options.outboundService
          ),
          cacheApiOutbound: { name: getCacheServiceName(workerIndex) }
        }
      }
    ];
    if (options.serviceBindings !== void 0) {
      for (const [name2, service] of Object.entries(options.serviceBindings)) {
        const maybeService = maybeGetCustomServiceService(
          workerIndex,
          "#" /* UNKNOWN */,
          name2,
          service
        );
        if (maybeService !== void 0)
          services.push(maybeService);
      }
    }
    if (options.outboundService !== void 0) {
      const maybeService = maybeGetCustomServiceService(
        workerIndex,
        "$" /* KNOWN */,
        CUSTOM_SERVICE_KNOWN_OUTBOUND,
        options.outboundService
      );
      if (maybeService !== void 0)
        services.push(maybeService);
    }
    return services;
  }
};
function getGlobalServices({
  sharedOptions,
  allWorkerRoutes,
  fallbackWorkerName,
  loopbackPort,
  log,
  proxyBindings
}) {
  const workerNames = [...allWorkerRoutes.keys()];
  const routes = parseRoutes(allWorkerRoutes);
  const serviceEntryBindings = [
    WORKER_BINDING_SERVICE_LOOPBACK,
    // For converting stack-traces to pretty-error pages
    { name: CoreBindings.JSON_ROUTES, json: JSON.stringify(routes) },
    { name: CoreBindings.JSON_CF_BLOB, json: JSON.stringify(sharedOptions.cf) },
    { name: CoreBindings.JSON_LOG_LEVEL, json: JSON.stringify(log.level) },
    {
      name: CoreBindings.SERVICE_USER_FALLBACK,
      service: { name: getUserServiceName(fallbackWorkerName) }
    },
    ...workerNames.map((name) => ({
      name: CoreBindings.SERVICE_USER_ROUTE_PREFIX + name,
      service: { name: getUserServiceName(name) }
    })),
    {
      name: CoreBindings.DURABLE_OBJECT_NAMESPACE_PROXY,
      durableObjectNamespace: { className: "ProxyServer" }
    },
    // Add `proxyBindings` here, they'll be added to the `ProxyServer` `env`.
    // It would be nice if we didn't add all these bindings to the entry worker,
    // but the entry worker shares lots of `devalue` code with the proxy, and
    // we'd rather not duplicate that.
    ...proxyBindings
  ];
  if (sharedOptions.upstream !== void 0) {
    serviceEntryBindings.push({
      name: CoreBindings.TEXT_UPSTREAM_URL,
      text: sharedOptions.upstream
    });
  }
  if (sharedOptions.liveReload) {
    const liveReloadScript = LIVE_RELOAD_SCRIPT_TEMPLATE(loopbackPort);
    serviceEntryBindings.push({
      name: CoreBindings.DATA_LIVE_RELOAD_SCRIPT,
      data: encoder3.encode(liveReloadScript)
    });
  }
  return [
    {
      name: SERVICE_LOOPBACK,
      external: { http: { cfBlobHeader: HEADER_CF_BLOB } }
    },
    {
      name: SERVICE_ENTRY,
      worker: {
        modules: [{ name: "entry.worker.js", esModule: entry_worker_default }],
        compatibilityDate: "2023-04-04",
        compatibilityFlags: ["nodejs_compat", "service_binding_extra_handlers"],
        bindings: serviceEntryBindings,
        durableObjectNamespaces: [
          {
            className: "ProxyServer",
            uniqueKey: `${SERVICE_ENTRY}-ProxyServer`
          }
        ],
        // `ProxyServer` doesn't make use of Durable Object storage
        durableObjectStorage: { inMemory: kVoid },
        // Always use the entrypoints cache implementation for proxying. This
        // means if the entrypoint disables caching, proxied cache operations
        // will be no-ops. Note we always require at least one worker to be set.
        cacheApiOutbound: { name: "cache:0" }
      }
    },
    {
      name: "internet",
      network: {
        // Allow access to private/public addresses:
        // https://github.com/cloudflare/miniflare/issues/412
        allow: ["public", "private"],
        deny: [],
        tlsOptions: {
          trustBrowserCas: true,
          trustedCertificates
        }
      }
    }
  ];
}
function getWorkerScript(sourceMapRegistry, options, workerIndex, additionalModuleNames) {
  const modulesRoot = ("modulesRoot" in options ? options.modulesRoot : void 0) ?? "";
  if (Array.isArray(options.modules)) {
    return {
      modules: options.modules.map(
        (module2) => convertModuleDefinition(sourceMapRegistry, modulesRoot, module2)
      )
    };
  }
  let code;
  if ("script" in options && options.script !== void 0) {
    code = options.script;
  } else if ("scriptPath" in options && options.scriptPath !== void 0) {
    code = (0, import_fs5.readFileSync)(options.scriptPath, "utf8");
  } else {
    import_assert16.default.fail("Unreachable: Workers must have code");
  }
  if (options.modules) {
    const locator = new ModuleLocator(
      sourceMapRegistry,
      modulesRoot,
      additionalModuleNames,
      options.modulesRules,
      options.compatibilityFlags
    );
    locator.visitEntrypoint(
      code,
      options.scriptPath ?? buildStringScriptPath(workerIndex)
    );
    return { modules: locator.modules };
  } else {
    if ("scriptPath" in options && options.scriptPath !== void 0) {
      code = sourceMapRegistry.register(code, options.scriptPath);
    }
    return { serviceWorkerScript: code };
  }
}

// packages/miniflare/src/plugins/d1/index.ts
var import_zod15 = require("zod");

// packages/miniflare/src/plugins/d1/gateway.ts
var import_crypto5 = __toESM(require("crypto"));
var import_promises7 = __toESM(require("fs/promises"));
var import_os = __toESM(require("os"));
var import_path12 = __toESM(require("path"));
var import_perf_hooks = require("perf_hooks");
var import_zod14 = require("zod");

// packages/miniflare/src/plugins/d1/splitter.ts
function mayContainMultipleStatements(sql) {
  const trimmed = sql.trimEnd();
  const semiColonIndex = trimmed.indexOf(";");
  return semiColonIndex !== -1 && semiColonIndex !== trimmed.length - 1;
}
function splitSqlQuery(sql) {
  if (!mayContainMultipleStatements(sql))
    return [sql];
  const split = splitSqlIntoStatements(sql);
  if (split.length === 0) {
    return [sql];
  } else {
    return split;
  }
}
function splitSqlIntoStatements(sql) {
  const statements = [];
  let str = "";
  const compoundStatementStack = [];
  const iterator = sql[Symbol.iterator]();
  let next = iterator.next();
  while (!next.done) {
    const char = next.value;
    if (compoundStatementStack[0]?.(str + char)) {
      compoundStatementStack.shift();
    }
    switch (char) {
      case `'`:
      case `"`:
      case "`":
        str += char + consumeUntilMarker(iterator, char);
        break;
      case `$`: {
        const dollarQuote = "$" + consumeWhile(iterator, isDollarQuoteIdentifier);
        str += dollarQuote;
        if (dollarQuote.endsWith("$")) {
          str += consumeUntilMarker(iterator, dollarQuote);
        }
        break;
      }
      case `-`:
        str += char;
        next = iterator.next();
        if (!next.done && next.value === "-") {
          str += next.value + consumeUntilMarker(iterator, "\n");
          break;
        } else {
          continue;
        }
      case `/`:
        str += char;
        next = iterator.next();
        if (!next.done && next.value === "*") {
          str += next.value + consumeUntilMarker(iterator, "*/");
          break;
        } else {
          continue;
        }
      case `;`:
        if (compoundStatementStack.length === 0) {
          statements.push(str);
          str = "";
        } else {
          str += char;
        }
        break;
      default:
        str += char;
        break;
    }
    if (isCompoundStatementStart(str)) {
      compoundStatementStack.unshift(isCompoundStatementEnd);
    }
    next = iterator.next();
  }
  statements.push(str);
  return statements.map((statement) => statement.trim()).filter((statement) => statement.length > 0);
}
function consumeWhile(iterator, predicate) {
  let next = iterator.next();
  let str = "";
  while (!next.done) {
    str += next.value;
    if (!predicate(str)) {
      break;
    }
    next = iterator.next();
  }
  return str;
}
function consumeUntilMarker(iterator, endMarker) {
  return consumeWhile(iterator, (str) => !str.endsWith(endMarker));
}
function isDollarQuoteIdentifier(str) {
  const lastChar = str.slice(-1);
  return (
    // The $ marks the end of the identifier
    lastChar !== "$" && // we allow numbers, underscore and letters with diacritical marks
    (/[0-9_]/i.test(lastChar) || lastChar.toLowerCase() !== lastChar.toUpperCase())
  );
}
function isCompoundStatementStart(str) {
  return /\sBEGIN\s$/.test(str);
}
function isCompoundStatementEnd(str) {
  return /\sEND[;\s]$/.test(str);
}

// packages/miniflare/src/plugins/d1/gateway.ts
var D1ValueSchema = import_zod14.z.union([
  // https://github.com/cloudflare/workers-sdk/blob/f7d49ebabc242a645ea6f8b34a8a6a285e252740/packages/wrangler/templates/d1-beta-facade.js#L114-L146
  import_zod14.z.number(),
  import_zod14.z.string(),
  import_zod14.z.null(),
  import_zod14.z.number().array()
]);
var D1SingleQuerySchema = import_zod14.z.object({
  sql: import_zod14.z.string(),
  params: import_zod14.z.array(D1ValueSchema).nullable().optional()
});
var D1QuerySchema = import_zod14.z.union([
  D1SingleQuerySchema,
  import_zod14.z.array(D1SingleQuerySchema)
]);
var served_by = "miniflare.db";
function ok(results, meta) {
  const duration = import_perf_hooks.performance.now() - meta.start;
  return {
    results,
    duration,
    success: true,
    served_by,
    meta: {
      duration,
      last_row_id: meta.last_row_id ?? 0,
      changes: meta.changes ?? 0,
      served_by,
      internal_stats: null
    },
    // These are deprecated in place of `meta`
    lastRowId: null,
    changes: null
  };
}
function err(error) {
  return {
    error: String(error),
    success: false,
    served_by
  };
}
var D1Error = class extends HttpError {
  constructor(cause) {
    super(500, void 0, cause);
  }
  toResponse() {
    return Response.json(err(this.cause));
  }
};
function normaliseParams(params) {
  return (params ?? []).map(
    (param) => (
      // If `param` is an array, assume it's a byte array
      Array.isArray(param) ? Buffer.from(param) : param
    )
  );
}
function normaliseResults(rows) {
  return rows.map(
    (row) => Object.fromEntries(
      Object.entries(row).map(([key, value]) => {
        let normalised;
        if (value instanceof Buffer) {
          normalised = Array.from(value);
        } else if (typeof value === "bigint") {
          normalised = Number(value);
        } else {
          normalised = value;
        }
        return [key, normalised];
      })
    )
  );
}
var EXECUTE_RETURNS_DATA_MESSAGE = "SQL execute error: Execute returned results - did you mean to call query?";
var CHANGES_QUERY = "SELECT total_changes() AS totalChanges";
var CHANGES_LAST_ROW_QUERY = "SELECT total_changes() AS totalChanges, changes() AS changes, last_insert_rowid() AS lastRowId";
var D1Gateway = class {
  constructor(log, storage) {
    this.log = log;
    this.db = storage.db;
  }
  db;
  #prepareAndBind(query) {
    const sql = splitSqlQuery(query.sql)[0];
    const stmt = this.db.prepare(sql);
    const params = normaliseParams(query.params);
    if (params.length === 0)
      return stmt;
    try {
      return stmt.bind(params);
    } catch (e) {
      try {
        return stmt.bind(Object.fromEntries(params.map((v, i) => [i + 1, v])));
      } catch {
      }
      throw e;
    }
  }
  #getTotalChanges() {
    const result = this.db.prepare(CHANGES_QUERY).get();
    return result.totalChanges;
  }
  #getChangesLastRow() {
    return this.db.prepare(CHANGES_LAST_ROW_QUERY).get();
  }
  #query = (query) => {
    const meta = { start: import_perf_hooks.performance.now() };
    const stmt = this.#prepareAndBind(query);
    let results;
    if (stmt.reader) {
      const initialTotalChanges = this.#getTotalChanges();
      results = stmt.all();
      const { totalChanges, changes, lastRowId } = this.#getChangesLastRow();
      if (totalChanges > initialTotalChanges) {
        meta.last_row_id = Number(lastRowId);
        meta.changes = Number(changes);
      }
    } else {
      const result = stmt.run();
      results = [];
      meta.last_row_id = Number(result.lastInsertRowid);
      meta.changes = result.changes;
    }
    return ok(normaliseResults(results), meta);
  };
  #execute = (query) => {
    const meta = { start: import_perf_hooks.performance.now() };
    const stmt = this.#prepareAndBind(query);
    if (stmt.reader)
      throw new Error(EXECUTE_RETURNS_DATA_MESSAGE);
    const result = stmt.run();
    meta.last_row_id = Number(result.lastInsertRowid);
    meta.changes = result.changes;
    return ok(null, meta);
  };
  #queryExecute(query, runner) {
    let results;
    if (Array.isArray(query)) {
      this.db.exec(`BEGIN TRANSACTION;`);
      try {
        results = query.map(runner);
        this.db.exec(`COMMIT;`);
      } catch (e) {
        this.db.exec(`ROLLBACK;`);
        throw e;
      }
    } else {
      results = runner(query);
    }
    return results;
  }
  query(query) {
    try {
      return this.#queryExecute(query, this.#query);
    } catch (e) {
      throw new D1Error(e);
    }
  }
  execute(query) {
    try {
      return this.#queryExecute(query, this.#execute);
    } catch (e) {
      throw new D1Error(e);
    }
  }
  async dump() {
    try {
      const random = import_crypto5.default.randomBytes(8).toString("hex");
      const tmpPath = import_path12.default.join(import_os.default.tmpdir(), `miniflare-d1-dump-${random}.db`);
      await this.db.backup(tmpPath);
      const buffer = await import_promises7.default.readFile(tmpPath);
      void import_promises7.default.unlink(tmpPath).catch(() => {
      });
      return buffer;
    } catch (e) {
      throw new D1Error(e);
    }
  }
};

// packages/miniflare/src/plugins/d1/router.ts
var D1Router = class extends Router {
  query = async (req, params) => {
    const persist = decodePersist(req.headers);
    const database = decodeURIComponent(params.database);
    const gateway = this.gatewayFactory.get(database, persist);
    const query = D1QuerySchema.parse(await req.json());
    const results = gateway.query(query);
    return Response.json(results);
  };
  execute = async (req, params) => {
    const persist = decodePersist(req.headers);
    const database = decodeURIComponent(params.database);
    const gateway = this.gatewayFactory.get(database, persist);
    const query = D1QuerySchema.parse(await req.json());
    const results = gateway.execute(query);
    return Response.json(results);
  };
  dump = async (req, params) => {
    const persist = decodePersist(req.headers);
    const database = decodeURIComponent(params.database);
    const gateway = this.gatewayFactory.get(database, persist);
    const buffer = await gateway.dump();
    return new Response(buffer, {
      headers: { "Content-Type": "application/octet-stream" }
    });
  };
};
__decorateClass([
  POST("/:database/query")
], D1Router.prototype, "query", 2);
__decorateClass([
  POST("/:database/execute")
], D1Router.prototype, "execute", 2);
__decorateClass([
  POST("/:database/dump")
], D1Router.prototype, "dump", 2);

// packages/miniflare/src/plugins/d1/index.ts
var D1OptionsSchema = import_zod15.z.object({
  d1Databases: import_zod15.z.union([import_zod15.z.record(import_zod15.z.string()), import_zod15.z.string().array()]).optional()
});
var D1SharedOptionsSchema = import_zod15.z.object({
  d1Persist: PersistenceSchema
});
var D1_PLUGIN_NAME = "d1";
var SERVICE_DATABASE_PREFIX = `${D1_PLUGIN_NAME}:db`;
var D1_PLUGIN = {
  gateway: D1Gateway,
  router: D1Router,
  options: D1OptionsSchema,
  sharedOptions: D1SharedOptionsSchema,
  getBindings(options) {
    const databases = namespaceEntries(options.d1Databases);
    return databases.map(([name, id]) => {
      const binding = name.startsWith("__D1_BETA__") ? (
        // Used before Wrangler 3.3
        {
          service: { name: `${SERVICE_DATABASE_PREFIX}:${id}` }
        }
      ) : (
        // Used after Wrangler 3.3
        {
          wrapped: {
            moduleName: "cloudflare-internal:d1-api",
            innerBindings: [
              {
                name: "fetcher",
                service: { name: `${SERVICE_DATABASE_PREFIX}:${id}` }
              }
            ]
          }
        }
      );
      return { name, ...binding };
    });
  },
  getNodeBindings(options) {
    const databases = namespaceKeys(options.d1Databases);
    return Object.fromEntries(
      databases.map((name) => [name, kProxyNodeBinding])
    );
  },
  getServices({ options, sharedOptions }) {
    const persist = sharedOptions.d1Persist;
    const databases = namespaceEntries(options.d1Databases);
    return databases.map(([_, id]) => ({
      name: `${SERVICE_DATABASE_PREFIX}:${id}`,
      worker: pluginNamespacePersistWorker(
        D1_PLUGIN_NAME,
        encodeURIComponent(id),
        persist
      )
    }));
  }
};

// packages/miniflare/src/plugins/queues/index.ts
var import_semiver = __toESM(require_semiver());
var import_zod18 = require("zod");

// packages/miniflare/src/plugins/queues/errors.ts
var QueuesError = class extends MiniflareError {
};
var QueuesHTTPError = class extends HttpError {
};

// packages/miniflare/src/plugins/queues/gateway.ts
var import_assert17 = __toESM(require("assert"));
var import_crypto6 = __toESM(require("crypto"));
var import_v8 = __toESM(require("v8"));
var import_colors6 = require("kleur/colors");
var import_zod16 = require("zod");
var DEFAULT_BATCH_SIZE = 5;
var DEFAULT_BATCH_TIMEOUT = 1;
var DEFAULT_RETRIES = 2;
var OutcomeSchema = import_zod16.z.enum([
  "unknown",
  "ok",
  "exception",
  "exceededCpu",
  "killSwitch",
  "daemonDown",
  "scriptNotFound",
  "cancelled",
  "exceededMemory"
]);
var QueueResponseSchema = import_zod16.z.object({
  outcome: OutcomeSchema,
  retryAll: import_zod16.z.boolean(),
  ackAll: import_zod16.z.boolean(),
  explicitRetries: import_zod16.z.string().array(),
  explicitAcks: import_zod16.z.string().array(),
  time: import_zod16.z.number().optional()
  // (added by Miniflare)
});
var exceptionQueueResponse = {
  outcome: "exception",
  retryAll: false,
  ackAll: false,
  explicitRetries: [],
  explicitAcks: []
};
var QueueContentTypeSchema = import_zod16.z.enum(["text", "json", "bytes", "v8"]).default("v8");
var GatewayMessageSchema = import_zod16.z.object({
  body: Base64DataSchema,
  contentType: QueueContentTypeSchema
});
var Message2 = class {
  constructor(id, timestamp, body) {
    this.id = id;
    this.timestamp = timestamp;
    this.body = body;
  }
  #failedAttempts = 0;
  incrementFailedAttempts() {
    return ++this.#failedAttempts;
  }
};
function formatQueueResponse(queueName, acked, total, time) {
  let colour;
  if (acked === total)
    colour = import_colors6.green;
  else if (acked > 0)
    colour = import_colors6.yellow;
  else
    colour = import_colors6.red;
  let message = `${(0, import_colors6.bold)("QUEUE")} ${queueName} ${colour(`${acked}/${total}`)}`;
  if (time !== void 0)
    message += (0, import_colors6.grey)(` (${time}ms)`);
  return (0, import_colors6.reset)(message);
}
var QueuesGateway = class {
  constructor(log, _storage2, timers, queueName, dispatchFetch) {
    this.log = log;
    this.timers = timers;
    this.queueName = queueName;
    this.dispatchFetch = dispatchFetch;
    this.#queueUrl = new URL(`http://entry/${queueName}`);
  }
  #queueUrl;
  #messages = [];
  #pendingFlush;
  async #dispatchBatch(workerName, batch) {
    const messages = batch.map((message) => ({ ...message }));
    const response = await this.dispatchFetch(this.#queueUrl, {
      method: "POST",
      headers: {
        "Content-Type": "application/json; charset=utf-8",
        [CoreHeaders.ROUTE_OVERRIDE]: workerName,
        [CoreHeaders.CUSTOM_EVENT]: "queue"
      },
      body: stringify(messages, structuredSerializableReducers)
    });
    if (!response.ok)
      import_assert17.default.fail(await response.text());
    return QueueResponseSchema.parse(await response.json());
  }
  #flush = async (enqueueOn, consumer) => {
    const batchSize = consumer.maxBatchSize ?? DEFAULT_BATCH_SIZE;
    const maxAttempts = (consumer.maxRetires ?? DEFAULT_RETRIES) + 1;
    const maxAttemptsS = maxAttempts === 1 ? "" : "s";
    const batch = this.#messages.splice(0, batchSize);
    let response;
    try {
      response = await this.#dispatchBatch(consumer.workerName, batch);
    } catch (e) {
      this.log.error(e);
      response = exceptionQueueResponse;
    }
    const retryAll = response.retryAll || response.outcome !== "ok";
    const explicitRetries = new Set(response.explicitRetries);
    let failedMessages = 0;
    const toRetry = [];
    const toDeadLetterQueue = [];
    for (const message of batch) {
      if (retryAll || explicitRetries.has(message.id)) {
        failedMessages++;
        const failedAttempts = message.incrementFailedAttempts();
        if (failedAttempts < maxAttempts) {
          this.log.debug(
            `Retrying message "${message.id}" on queue "${this.queueName}"...`
          );
          toRetry.push(message);
        } else if (consumer.deadLetterQueue !== void 0) {
          this.log.warn(
            `Moving message "${message.id}" on queue "${this.queueName}" to dead letter queue "${consumer.deadLetterQueue}" after ${maxAttempts} failed attempt${maxAttemptsS}...`
          );
          toDeadLetterQueue.push(message);
        } else {
          this.log.warn(
            `Dropped message "${message.id}" on queue "${this.queueName}" after ${maxAttempts} failed attempt${maxAttemptsS}!`
          );
        }
      }
    }
    const acked = batch.length - failedMessages;
    this.log.info(
      formatQueueResponse(this.queueName, acked, batch.length, response.time)
    );
    this.#messages.push(...toRetry);
    this.#pendingFlush = void 0;
    if (this.#messages.length > 0) {
      this.#ensurePendingFlush(enqueueOn, consumer);
    }
    if (toDeadLetterQueue.length > 0) {
      (0, import_assert17.default)(consumer.deadLetterQueue !== void 0);
      (0, import_assert17.default)(consumer.deadLetterConsumer !== void 0);
      enqueueOn(
        consumer.deadLetterQueue,
        consumer.deadLetterConsumer,
        toDeadLetterQueue
        // Reuse same message instances with same IDs
      );
    }
  };
  #ensurePendingFlush(enqueueOn, consumer) {
    const batchSize = consumer.maxBatchSize ?? DEFAULT_BATCH_SIZE;
    const batchTimeout = consumer.maxBatchTimeout ?? DEFAULT_BATCH_TIMEOUT;
    const batchHasSpace = this.#messages.length < batchSize;
    if (this.#pendingFlush !== void 0) {
      if (this.#pendingFlush.immediate || batchHasSpace)
        return;
      this.timers.clearTimeout(this.#pendingFlush.timeout);
      this.#pendingFlush = void 0;
    }
    const delay = batchHasSpace ? batchTimeout * 1e3 : 0;
    const timeout = this.timers.setTimeout(
      this.#flush,
      delay,
      enqueueOn,
      consumer
    );
    this.#pendingFlush = { immediate: delay === 0, timeout };
  }
  enqueue(enqueueOn, consumer, messages) {
    for (const message of messages) {
      if (message instanceof Message2) {
        this.#messages.push(message);
      } else {
        const id = import_crypto6.default.randomBytes(16).toString("hex");
        const timestamp = this.timers.now();
        let body;
        if (message.contentType === "text") {
          body = message.body.toString();
        } else if (message.contentType === "json") {
          body = JSON.parse(message.body.toString());
        } else if (message.contentType === "bytes") {
          body = viewToBuffer(message.body);
        } else {
          body = import_v8.default.deserialize(message.body);
        }
        this.#messages.push(new Message2(id, timestamp, body));
      }
    }
    this.#ensurePendingFlush(enqueueOn, consumer);
  }
};

// packages/miniflare/src/plugins/queues/router.ts
var import_zod17 = require("zod");
var MAX_MESSAGE_SIZE_BYTES = 128 * 1e3;
var MAX_MESSAGE_BATCH_COUNT = 100;
var MAX_MESSAGE_BATCH_SIZE = (256 + 32) * 1e3;
var PayloadTooLargeError = class extends HttpError {
  constructor(message) {
    super(413, message);
  }
};
function validateMessageSize(headers) {
  const size = headers.get("Content-Length");
  if (size !== null && parseInt(size) > MAX_MESSAGE_SIZE_BYTES) {
    throw new PayloadTooLargeError(
      `message length of ${size} bytes exceeds limit of ${MAX_MESSAGE_SIZE_BYTES}`
    );
  }
}
function validateContentType(headers) {
  const format = headers.get("X-Msg-Fmt") ?? void 0;
  const result = QueueContentTypeSchema.safeParse(format);
  if (!result.success) {
    throw new HttpError(
      400,
      `message content type ${format} is invalid; if specified, must be one of 'text', 'json', 'bytes', or 'v8'`
    );
  } else {
    return result.data;
  }
}
function validateBatchSize(headers) {
  const count = headers.get("CF-Queue-Batch-Count");
  if (count !== null && parseInt(count) > MAX_MESSAGE_BATCH_COUNT) {
    throw new PayloadTooLargeError(
      `batch message count of ${count} exceeds limit of ${MAX_MESSAGE_BATCH_COUNT}`
    );
  }
  const largestSize = headers.get("CF-Queue-Largest-Msg");
  if (largestSize !== null && parseInt(largestSize) > MAX_MESSAGE_SIZE_BYTES) {
    throw new PayloadTooLargeError(
      `message in batch has length ${largestSize} bytes which exceeds single message size limit of ${MAX_MESSAGE_SIZE_BYTES}`
    );
  }
  const batchSize = headers.get("CF-Queue-Batch-Bytes");
  if (batchSize !== null && parseInt(batchSize) > MAX_MESSAGE_BATCH_SIZE) {
    throw new PayloadTooLargeError(
      `batch size of ${batchSize} bytes exceeds limit of 256000`
    );
  }
}
async function decodeQueueConsumer(headers) {
  const header = headers.get(HEADER_PERSIST);
  return header === null ? void 0 : parse(JSON.parse(header));
}
var QueuesBatchRequestSchema = import_zod17.z.object({
  messages: import_zod17.z.array(GatewayMessageSchema)
});
var QueuesRouter = class extends Router {
  #enqueueOn = (queueName, consumer, messages) => {
    const gateway = this.gatewayFactory.get(queueName, void 0);
    gateway.enqueue(this.#enqueueOn, consumer, messages);
  };
  message = async (req, params) => {
    validateMessageSize(req.headers);
    const contentType = validateContentType(req.headers);
    const consumer = await decodeQueueConsumer(req.headers);
    if (consumer === void 0)
      return new Response();
    const queue = decodeURIComponent(params.queue);
    this.#enqueueOn(queue, consumer, [
      {
        body: Buffer.from(await req.arrayBuffer()),
        contentType
      }
    ]);
    return new Response();
  };
  batch = async (req, params) => {
    validateBatchSize(req.headers);
    const consumer = await decodeQueueConsumer(req.headers);
    if (consumer === void 0)
      return new Response();
    const queue = decodeURIComponent(params.queue);
    const body = QueuesBatchRequestSchema.parse(await req.json());
    this.#enqueueOn(queue, consumer, body.messages);
    return new Response();
  };
};
__decorateClass([
  POST("/:queue/message")
], QueuesRouter.prototype, "message", 2);
__decorateClass([
  POST("/:queue/batch")
], QueuesRouter.prototype, "batch", 2);

// packages/miniflare/src/plugins/queues/index.ts
var QueuesOptionsSchema = import_zod18.z.object({
  queueProducers: import_zod18.z.union([import_zod18.z.record(import_zod18.z.string()), import_zod18.z.string().array()]).optional(),
  queueConsumers: import_zod18.z.union([import_zod18.z.record(QueueConsumerOptionsSchema), import_zod18.z.string().array()]).optional()
});
var _QUEUES_COMPATIBLE_V8_VERSION = (0, import_semiver.default)(process.versions.v8, "10.0.29") >= 0;
function assertCompatibleV8Version() {
  if (!_QUEUES_COMPATIBLE_V8_VERSION) {
    throw new QueuesError(
      "ERR_V8_UNSUPPORTED",
      "The version of V8 bundled with this version of Node.js does not support Queues. Please upgrade to the latest Node.js LTS release."
    );
  }
}
var QUEUES_PLUGIN_NAME = "queues";
var QUEUES_PLUGIN = {
  gateway: QueuesGateway,
  router: QueuesRouter,
  options: QueuesOptionsSchema,
  getBindings(options) {
    const queues = namespaceEntries(options.queueProducers);
    const hasProducers = queues.length > 0;
    const hasConsumers = Object.keys(options.queueConsumers ?? {}).length > 0;
    if (hasProducers || hasConsumers)
      assertCompatibleV8Version();
    return queues.map(([name, id]) => ({
      name,
      queue: { name: `${QUEUES_PLUGIN_NAME}:${id}` }
    }));
  },
  getNodeBindings(options) {
    const queues = namespaceKeys(options.queueProducers);
    return Object.fromEntries(queues.map((name) => [name, kProxyNodeBinding]));
  },
  async getServices({ options, queueConsumers: allQueueConsumers }) {
    const queues = namespaceEntries(options.queueProducers);
    if (queues.length === 0)
      return [];
    return queues.map(([_, id]) => {
      const consumer = allQueueConsumers.get(id);
      const persist = maybeApply(stringify, consumer);
      return {
        name: `${QUEUES_PLUGIN_NAME}:${id}`,
        worker: pluginNamespacePersistWorker(
          QUEUES_PLUGIN_NAME,
          encodeURIComponent(id),
          persist
        )
      };
    });
  }
};

// packages/miniflare/src/plugins/r2/index.ts
var import_zod20 = require("zod");

// packages/miniflare/src/plugins/r2/gateway.ts
var import_assert19 = __toESM(require("assert"));
var import_crypto7 = __toESM(require("crypto"));
var import_web10 = require("stream/web");

// packages/miniflare/src/plugins/r2/errors.ts
var R2Error = class extends HttpError {
  constructor(code, message, v4Code) {
    super(code, message);
    this.v4Code = v4Code;
  }
  object;
  toResponse() {
    if (this.object !== void 0) {
      const { metadataSize, value } = this.object.encode();
      return new Response(value, {
        status: this.code,
        headers: {
          ["cf-r2-metadata-size" /* MetadataSize */]: `${metadataSize}`,
          "Content-Type": "application/json",
          ["cf-r2-error" /* Error */]: JSON.stringify({
            message: this.message,
            version: 1,
            // Note the lowercase 'c', which the runtime expects
            v4code: this.v4Code
          })
        }
      });
    }
    return new Response(null, {
      status: this.code,
      headers: {
        ["cf-r2-error" /* Error */]: JSON.stringify({
          message: this.message,
          version: 1,
          // Note the lowercase 'c', which the runtime expects
          v4code: this.v4Code
        })
      }
    });
  }
  context(info) {
    this.message += ` (${info})`;
    return this;
  }
  attach(object) {
    this.object = object;
    return this;
  }
};
var InvalidMetadata = class extends R2Error {
  constructor() {
    super(
      400 /* BadRequest */,
      "Metadata missing or invalid",
      10029 /* InvalidArgument */
    );
  }
};
var InternalError = class extends R2Error {
  constructor() {
    super(
      500 /* InternalError */,
      "We encountered an internal error. Please try again.",
      10001 /* InternalError */
    );
  }
};
var NoSuchKey = class extends R2Error {
  constructor() {
    super(
      404 /* NotFound */,
      "The specified key does not exist.",
      10007 /* NoSuchObjectKey */
    );
  }
};
var EntityTooLarge = class extends R2Error {
  constructor() {
    super(
      400 /* BadRequest */,
      "Your proposed upload exceeds the maximum allowed object size.",
      100100 /* EntityTooLarge */
    );
  }
};
var EntityTooSmall = class extends R2Error {
  constructor() {
    super(
      400 /* BadRequest */,
      "Your proposed upload is smaller than the minimum allowed object size.",
      10011 /* EntityTooSmall */
    );
  }
};
var MetadataTooLarge = class extends R2Error {
  constructor() {
    super(
      400 /* BadRequest */,
      "Your metadata headers exceed the maximum allowed metadata size.",
      10012 /* MetadataTooLarge */
    );
  }
};
var BadDigest = class extends R2Error {
  constructor(algorithm, provided, calculated) {
    super(
      400 /* BadRequest */,
      [
        `The ${algorithm} checksum you specified did not match what we received.`,
        `You provided a ${algorithm} checksum with value: ${provided.toString(
          "hex"
        )}`,
        `Actual ${algorithm} was: ${calculated.toString("hex")}`
      ].join("\n"),
      10037 /* BadDigest */
    );
  }
};
var InvalidObjectName = class extends R2Error {
  constructor() {
    super(
      400 /* BadRequest */,
      "The specified object name is not valid.",
      10020 /* InvalidObjectName */
    );
  }
};
var InvalidMaxKeys = class extends R2Error {
  constructor() {
    super(
      400 /* BadRequest */,
      "MaxKeys params must be positive integer <= 1000.",
      10022 /* InvalidMaxKeys */
    );
  }
};
var NoSuchUpload = class extends R2Error {
  constructor() {
    super(
      400 /* BadRequest */,
      "The specified multipart upload does not exist.",
      10024 /* NoSuchUpload */
    );
  }
};
var InvalidPart = class extends R2Error {
  constructor() {
    super(
      400 /* BadRequest */,
      "One or more of the specified parts could not be found.",
      10025 /* InvalidPart */
    );
  }
};
var PreconditionFailed = class extends R2Error {
  constructor() {
    super(
      412 /* PreconditionFailed */,
      "At least one of the pre-conditions you specified did not hold.",
      10031 /* PreconditionFailed */
    );
  }
};
var InvalidRange = class extends R2Error {
  constructor() {
    super(
      416 /* RangeNotSatisfiable */,
      "The requested range is not satisfiable",
      10039 /* InvalidRange */
    );
  }
};
var BadUpload = class extends R2Error {
  constructor() {
    super(
      416 /* RangeNotSatisfiable */,
      "There was a problem with the multipart upload.",
      10048 /* BadUpload */
    );
  }
};

// packages/miniflare/src/plugins/r2/r2Object.ts
var import_buffer2 = require("buffer");
var import_web9 = require("stream/web");
var InternalR2Object = class {
  key;
  version;
  size;
  etag;
  uploaded;
  httpMetadata;
  customMetadata;
  range;
  checksums;
  constructor(row, range) {
    this.key = row.key;
    this.version = row.version;
    this.size = row.size;
    this.etag = row.etag;
    this.uploaded = row.uploaded;
    this.httpMetadata = JSON.parse(row.http_metadata);
    this.customMetadata = JSON.parse(row.custom_metadata);
    this.range = range;
    const checksums = JSON.parse(row.checksums);
    if (this.etag.length === 32 && HEX_REGEXP.test(this.etag)) {
      checksums.md5 = row.etag;
    }
    this.checksums = checksums;
  }
  // Format for return to the Workers Runtime
  #rawProperties() {
    return {
      name: this.key,
      version: this.version,
      size: this.size,
      etag: this.etag,
      uploaded: this.uploaded,
      httpFields: this.httpMetadata,
      customFields: Object.entries(this.customMetadata).map(([k, v]) => ({
        k,
        v
      })),
      range: this.range,
      checksums: {
        0: this.checksums.md5,
        1: this.checksums.sha1,
        2: this.checksums.sha256,
        3: this.checksums.sha384,
        4: this.checksums.sha512
      }
    };
  }
  encode() {
    const json = JSON.stringify(this.#rawProperties());
    const blob = new import_buffer2.Blob([json]);
    return { metadataSize: blob.size, value: blob.stream() };
  }
  static encodeMultiple(objects) {
    const json = JSON.stringify({
      ...objects,
      objects: objects.objects.map((o) => o.#rawProperties())
    });
    const blob = new import_buffer2.Blob([json]);
    return { metadataSize: blob.size, value: blob.stream() };
  }
};
var InternalR2ObjectBody = class extends InternalR2Object {
  constructor(metadata, body, range) {
    super(metadata, range);
    this.body = body;
  }
  encode() {
    const { metadataSize, value: metadata } = super.encode();
    const identity2 = new import_web9.TransformStream();
    void metadata.pipeTo(identity2.writable, { preventClose: true }).then(() => this.body.pipeTo(identity2.writable));
    return {
      metadataSize,
      value: identity2.readable
    };
  }
};

// packages/miniflare/src/plugins/r2/schemas.ts
var import_zod19 = require("zod");
var MultipartUploadState = {
  IN_PROGRESS: 0,
  COMPLETED: 1,
  ABORTED: 2
};
var SQL_SCHEMA2 = `
CREATE TABLE IF NOT EXISTS _mf_objects (
    key TEXT PRIMARY KEY,
    blob_id TEXT,
    version TEXT NOT NULL,
    size INTEGER NOT NULL,
    etag TEXT NOT NULL,
    uploaded INTEGER NOT NULL,
    checksums TEXT NOT NULL,
    http_metadata TEXT NOT NULL,
    custom_metadata TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS _mf_multipart_uploads (
    upload_id TEXT PRIMARY KEY,
    key TEXT NOT NULL,
    http_metadata TEXT NOT NULL,
    custom_metadata TEXT NOT NULL,
    state TINYINT DEFAULT 0 NOT NULL
);
CREATE TABLE IF NOT EXISTS _mf_multipart_parts (
    upload_id TEXT NOT NULL REFERENCES _mf_multipart_uploads(upload_id),
    part_number INTEGER NOT NULL,
    blob_id TEXT NOT NULL,
    size INTEGER NOT NULL,
    etag TEXT NOT NULL,
    checksum_md5 TEXT NOT NULL,
    object_key TEXT REFERENCES _mf_objects(key) DEFERRABLE INITIALLY DEFERRED,
    PRIMARY KEY (upload_id, part_number)
);
`;
var DateSchema = import_zod19.z.coerce.number().transform((value) => new Date(value));
var RecordSchema = import_zod19.z.object({
  k: import_zod19.z.string(),
  v: import_zod19.z.string()
}).array().transform(
  (entries) => Object.fromEntries(entries.map(({ k, v }) => [k, v]))
);
var R2RangeSchema = import_zod19.z.object({
  offset: import_zod19.z.coerce.number().optional(),
  length: import_zod19.z.coerce.number().optional(),
  suffix: import_zod19.z.coerce.number().optional()
});
var R2EtagSchema = import_zod19.z.discriminatedUnion("type", [
  import_zod19.z.object({ type: import_zod19.z.literal("strong"), value: import_zod19.z.string() }),
  import_zod19.z.object({ type: import_zod19.z.literal("weak"), value: import_zod19.z.string() }),
  import_zod19.z.object({ type: import_zod19.z.literal("wildcard") })
]);
var R2EtagMatchSchema = R2EtagSchema.array().min(1).optional();
var R2ConditionalSchema = import_zod19.z.object({
  // Performs the operation if the object's ETag matches the given string
  etagMatches: R2EtagMatchSchema,
  // "If-Match"
  // Performs the operation if the object's ETag does NOT match the given string
  etagDoesNotMatch: R2EtagMatchSchema,
  // "If-None-Match"
  // Performs the operation if the object was uploaded BEFORE the given date
  uploadedBefore: DateSchema.optional(),
  // "If-Unmodified-Since"
  // Performs the operation if the object was uploaded AFTER the given date
  uploadedAfter: DateSchema.optional(),
  // "If-Modified-Since"
  // Truncates dates to seconds before performing comparisons
  secondsGranularity: import_zod19.z.oboolean()
});
var R2ChecksumsSchema = import_zod19.z.object({
  0: HexDataSchema.optional(),
  1: HexDataSchema.optional(),
  2: HexDataSchema.optional(),
  3: HexDataSchema.optional(),
  4: HexDataSchema.optional()
}).transform((checksums) => ({
  md5: checksums["0"],
  sha1: checksums["1"],
  sha256: checksums["2"],
  sha384: checksums["3"],
  sha512: checksums["4"]
}));
var R2PublishedPartSchema = import_zod19.z.object({
  etag: import_zod19.z.string(),
  part: import_zod19.z.number()
});
var R2HttpFieldsSchema = import_zod19.z.object({
  contentType: import_zod19.z.ostring(),
  contentLanguage: import_zod19.z.ostring(),
  contentDisposition: import_zod19.z.ostring(),
  contentEncoding: import_zod19.z.ostring(),
  cacheControl: import_zod19.z.ostring(),
  cacheExpiry: import_zod19.z.coerce.number().optional()
});
var R2HeadRequestSchema = import_zod19.z.object({
  method: import_zod19.z.literal("head"),
  object: import_zod19.z.string()
});
var R2GetRequestSchema = import_zod19.z.object({
  method: import_zod19.z.literal("get"),
  object: import_zod19.z.string(),
  // Specifies that only a specific length (from an optional offset) or suffix
  // of bytes from the object should be returned. Refer to
  // https://developers.cloudflare.com/r2/runtime-apis/#ranged-reads.
  range: R2RangeSchema.optional(),
  rangeHeader: import_zod19.z.ostring(),
  // Specifies that the object should only be returned given satisfaction of
  // certain conditions in the R2Conditional. Refer to R2Conditional above.
  onlyIf: R2ConditionalSchema.optional()
});
var R2PutRequestSchema = import_zod19.z.object({
  method: import_zod19.z.literal("put"),
  object: import_zod19.z.string(),
  customFields: RecordSchema.optional(),
  // (renamed in transform)
  httpFields: R2HttpFieldsSchema.optional(),
  // (renamed in transform)
  onlyIf: R2ConditionalSchema.optional(),
  md5: Base64DataSchema.optional(),
  // (intentionally base64, not hex)
  sha1: HexDataSchema.optional(),
  sha256: HexDataSchema.optional(),
  sha384: HexDataSchema.optional(),
  sha512: HexDataSchema.optional()
}).transform((value) => ({
  method: value.method,
  object: value.object,
  customMetadata: value.customFields,
  httpMetadata: value.httpFields,
  onlyIf: value.onlyIf,
  md5: value.md5,
  sha1: value.sha1,
  sha256: value.sha256,
  sha384: value.sha384,
  sha512: value.sha512
}));
var R2CreateMultipartUploadRequestSchema = import_zod19.z.object({
  method: import_zod19.z.literal("createMultipartUpload"),
  object: import_zod19.z.string(),
  customFields: RecordSchema.optional(),
  // (renamed in transform)
  httpFields: R2HttpFieldsSchema.optional()
  // (renamed in transform)
}).transform((value) => ({
  method: value.method,
  object: value.object,
  customMetadata: value.customFields,
  httpMetadata: value.httpFields
}));
var R2UploadPartRequestSchema = import_zod19.z.object({
  method: import_zod19.z.literal("uploadPart"),
  object: import_zod19.z.string(),
  uploadId: import_zod19.z.string(),
  partNumber: import_zod19.z.number()
});
var R2CompleteMultipartUploadRequestSchema = import_zod19.z.object({
  method: import_zod19.z.literal("completeMultipartUpload"),
  object: import_zod19.z.string(),
  uploadId: import_zod19.z.string(),
  parts: R2PublishedPartSchema.array()
});
var R2AbortMultipartUploadRequestSchema = import_zod19.z.object({
  method: import_zod19.z.literal("abortMultipartUpload"),
  object: import_zod19.z.string(),
  uploadId: import_zod19.z.string()
});
var R2ListRequestSchema = import_zod19.z.object({
  method: import_zod19.z.literal("list"),
  limit: import_zod19.z.onumber(),
  prefix: import_zod19.z.ostring(),
  cursor: import_zod19.z.ostring(),
  delimiter: import_zod19.z.ostring(),
  startAfter: import_zod19.z.ostring(),
  include: import_zod19.z.union([import_zod19.z.literal(0), import_zod19.z.literal(1)]).transform((value) => value === 0 ? "httpMetadata" : "customMetadata").array().optional()
});
var R2DeleteRequestSchema = import_zod19.z.intersection(
  import_zod19.z.object({ method: import_zod19.z.literal("delete") }),
  import_zod19.z.union([
    import_zod19.z.object({ object: import_zod19.z.string() }),
    import_zod19.z.object({ objects: import_zod19.z.string().array() })
  ])
);
var R2BindingRequestSchema = import_zod19.z.union([
  R2HeadRequestSchema,
  R2GetRequestSchema,
  R2PutRequestSchema,
  R2CreateMultipartUploadRequestSchema,
  R2UploadPartRequestSchema,
  R2CompleteMultipartUploadRequestSchema,
  R2AbortMultipartUploadRequestSchema,
  R2ListRequestSchema,
  R2DeleteRequestSchema
]);

// packages/miniflare/src/plugins/r2/validator.ts
var import_assert18 = __toESM(require("assert"));
var MAX_LIST_KEYS2 = 1e3;
var MAX_KEY_SIZE2 = 1024;
var MAX_VALUE_SIZE2 = 5e9 - 5e6;
var MAX_METADATA_SIZE2 = 2048;
function identity(ms) {
  return ms;
}
function truncateToSeconds(ms) {
  return Math.floor(ms / 1e3) * 1e3;
}
function includesEtag(conditions, etag, comparison) {
  for (const condition of conditions) {
    if (condition.type === "wildcard")
      return true;
    if (condition.value === etag) {
      if (condition.type === "strong" || comparison === "weak")
        return true;
    }
  }
  return false;
}
function _testR2Conditional(cond, metadata) {
  if (metadata === void 0) {
    const ifMatch2 = cond.etagMatches === void 0;
    const ifModifiedSince2 = cond.uploadedAfter === void 0;
    return ifMatch2 && ifModifiedSince2;
  }
  const { etag, uploaded: lastModifiedRaw } = metadata;
  const ifMatch = cond.etagMatches === void 0 || includesEtag(cond.etagMatches, etag, "strong");
  const ifNoneMatch = cond.etagDoesNotMatch === void 0 || !includesEtag(cond.etagDoesNotMatch, etag, "weak");
  const maybeTruncate = cond.secondsGranularity ? truncateToSeconds : identity;
  const lastModified = maybeTruncate(lastModifiedRaw);
  const ifModifiedSince = cond.uploadedAfter === void 0 || maybeTruncate(cond.uploadedAfter.getTime()) < lastModified || cond.etagDoesNotMatch !== void 0 && ifNoneMatch;
  const ifUnmodifiedSince = cond.uploadedBefore === void 0 || lastModified < maybeTruncate(cond.uploadedBefore.getTime()) || cond.etagMatches !== void 0 && ifMatch;
  return ifMatch && ifNoneMatch && ifModifiedSince && ifUnmodifiedSince;
}
var R2_HASH_ALGORITHMS = [
  { name: "MD5", field: "md5" },
  { name: "SHA-1", field: "sha1" },
  { name: "SHA-256", field: "sha256" },
  { name: "SHA-384", field: "sha384" },
  { name: "SHA-512", field: "sha512" }
];
function serialisedLength(x) {
  for (let i = 0; i < x.length; i++) {
    if (x.charCodeAt(i) >= 256)
      return x.length * 2;
  }
  return x.length;
}
var Validator = class {
  hash(digests, hashes) {
    const checksums = {};
    for (const { name, field } of R2_HASH_ALGORITHMS) {
      const providedHash = hashes[field];
      if (providedHash !== void 0) {
        const computedHash = digests.get(field);
        (0, import_assert18.default)(computedHash !== void 0);
        if (!providedHash.equals(computedHash)) {
          throw new BadDigest(name, providedHash, computedHash);
        }
        checksums[field] = computedHash.toString("hex");
      }
    }
    return checksums;
  }
  condition(meta, onlyIf) {
    if (onlyIf !== void 0 && !_testR2Conditional(onlyIf, meta)) {
      throw new PreconditionFailed();
    }
    return this;
  }
  range(options, size) {
    if (options.rangeHeader !== void 0) {
      const ranges = _parseRanges(options.rangeHeader, size);
      if (ranges?.length === 1)
        return ranges[0];
    } else if (options.range !== void 0) {
      let { offset, length, suffix } = options.range;
      if (suffix !== void 0) {
        if (suffix <= 0)
          throw new InvalidRange();
        if (suffix > size)
          suffix = size;
        offset = size - suffix;
        length = suffix;
      }
      if (offset === void 0)
        offset = 0;
      if (length === void 0)
        length = size - offset;
      if (offset < 0 || offset > size || length <= 0)
        throw new InvalidRange();
      if (offset + length > size)
        length = size - offset;
      return { start: offset, end: offset + length - 1 };
    }
  }
  size(size) {
    if (size > MAX_VALUE_SIZE2) {
      throw new EntityTooLarge();
    }
    return this;
  }
  metadataSize(customMetadata) {
    if (customMetadata === void 0)
      return this;
    let metadataLength = 0;
    for (const [key, value] of Object.entries(customMetadata)) {
      metadataLength += serialisedLength(key) + serialisedLength(value);
    }
    if (metadataLength > MAX_METADATA_SIZE2) {
      throw new MetadataTooLarge();
    }
    return this;
  }
  key(key) {
    const keyLength = Buffer.byteLength(key);
    if (keyLength >= MAX_KEY_SIZE2) {
      throw new InvalidObjectName();
    }
    return this;
  }
  limit(limit) {
    if (limit !== void 0 && (limit < 1 || limit > MAX_LIST_KEYS2)) {
      throw new InvalidMaxKeys();
    }
    return this;
  }
};

// packages/miniflare/src/plugins/r2/gateway.ts
var DigestingStream = class extends import_web10.TransformStream {
  digests;
  constructor(algorithms) {
    const digests = new DeferredPromise();
    const hashes = algorithms.map((alg) => import_crypto7.default.createHash(alg));
    super({
      transform(chunk, controller) {
        for (const hash of hashes)
          hash.update(chunk);
        controller.enqueue(chunk);
      },
      flush() {
        const result = /* @__PURE__ */ new Map();
        for (let i = 0; i < hashes.length; i++) {
          result.set(algorithms[i], hashes[i].digest());
        }
        digests.resolve(result);
      }
    });
    this.digests = digests;
  }
};
var validate = new Validator();
function generateVersion() {
  return import_crypto7.default.randomBytes(16).toString("hex");
}
function generateId() {
  return import_crypto7.default.randomBytes(128).toString("base64url");
}
function generateMultipartEtag(md5Hexes) {
  const hash = import_crypto7.default.createHash("md5");
  for (const md5Hex of md5Hexes)
    hash.update(Buffer.from(md5Hex, "hex"));
  return `${hash.digest("hex")}-${md5Hexes.length}`;
}
function rangeOverlaps(a, b) {
  return a.start <= b.end && b.start <= a.end;
}
function sqlStmts2(db) {
  const stmtGetPreviousByKey = db.prepare("SELECT blob_id, etag, uploaded FROM _mf_objects WHERE key = :key");
  const stmtGetByKey = db.prepare(`
    SELECT key, blob_id, version, size, etag, uploaded, checksums, http_metadata, custom_metadata
    FROM _mf_objects WHERE key = :key
  `);
  const stmtPut = db.prepare(`
    INSERT OR REPLACE INTO _mf_objects (key, blob_id, version, size, etag, uploaded, checksums, http_metadata, custom_metadata)
    VALUES (:key, :blob_id, :version, :size, :etag, :uploaded, :checksums, :http_metadata, :custom_metadata)
  `);
  const stmtDelete = db.prepare("DELETE FROM _mf_objects WHERE key = :key RETURNING blob_id");
  function stmtListWithoutDelimiter(...extraColumns) {
    const columns = [
      "key",
      "version",
      "size",
      "etag",
      "uploaded",
      "checksums",
      ...extraColumns
    ];
    return db.prepare(`
      SELECT ${columns.join(", ")}
      FROM _mf_objects
      WHERE key LIKE :escaped_prefix || '%' ESCAPE '\\'
      AND (:start_after IS NULL OR key > :start_after)
      ORDER BY key LIMIT :limit
    `);
  }
  const stmtGetUploadState = db.prepare(
    // For checking current upload state
    "SELECT state FROM _mf_multipart_uploads WHERE upload_id = :upload_id AND key = :key"
  );
  const stmtGetUploadMetadata = db.prepare(
    // For checking current upload state, and getting metadata for completion
    "SELECT http_metadata, custom_metadata, state FROM _mf_multipart_uploads WHERE upload_id = :upload_id AND key = :key"
  );
  const stmtUpdateUploadState = db.prepare(
    // For completing/aborting uploads
    "UPDATE _mf_multipart_uploads SET state = :state WHERE upload_id = :upload_id"
  );
  const stmtGetPreviousPartByNumber = db.prepare(
    // For getting part number's previous blob ID to garbage collect
    "SELECT blob_id FROM _mf_multipart_parts WHERE upload_id = :upload_id AND part_number = :part_number"
  );
  const stmtPutPart = db.prepare(
    // For recording metadata when uploading parts
    `INSERT OR REPLACE INTO _mf_multipart_parts (upload_id, part_number, blob_id, size, etag, checksum_md5)
    VALUES (:upload_id, :part_number, :blob_id, :size, :etag, :checksum_md5)`
  );
  const stmtLinkPart = db.prepare(
    // For linking parts with an object when completing uploads
    `UPDATE _mf_multipart_parts SET object_key = :object_key
    WHERE upload_id = :upload_id AND part_number = :part_number`
  );
  const stmtDeletePartsByUploadId = db.prepare(
    // For deleting parts when aborting uploads
    "DELETE FROM _mf_multipart_parts WHERE upload_id = :upload_id RETURNING blob_id"
  );
  const stmtDeleteUnlinkedPartsByUploadId = db.prepare(
    // For deleting unused parts when completing uploads
    "DELETE FROM _mf_multipart_parts WHERE upload_id = :upload_id AND object_key IS NULL RETURNING blob_id"
  );
  const stmtDeletePartsByKey = db.prepare(
    // For deleting dangling parts when overwriting an existing key
    "DELETE FROM _mf_multipart_parts WHERE object_key = :object_key RETURNING blob_id"
  );
  const stmtListPartsByUploadId = db.prepare(
    // For getting part metadata when completing uploads
    `SELECT upload_id, part_number, blob_id, size, etag, checksum_md5, object_key
    FROM _mf_multipart_parts WHERE upload_id = :upload_id`
  );
  const stmtListPartsByKey = db.prepare(
    // For getting part metadata when getting values, size included for range
    // requests, so we only need to read blobs containing the required data
    "SELECT blob_id, size FROM _mf_multipart_parts WHERE object_key = :object_key ORDER BY part_number"
  );
  return {
    getByKey: stmtGetByKey,
    getPartsByKey: db.transaction((key) => {
      const row = stmtGetByKey.get({ key });
      if (row === void 0)
        return;
      if (row.blob_id === null) {
        const partsRows = stmtListPartsByKey.all({ object_key: key });
        return { row, parts: partsRows };
      } else {
        return { row };
      }
    }),
    put: db.transaction((newRow, onlyIf) => {
      const key = newRow.key;
      const row = stmtGetPreviousByKey.get({ key });
      if (onlyIf !== void 0)
        validate.condition(row, onlyIf);
      stmtPut.run(newRow);
      const maybeOldBlobId = row?.blob_id;
      if (maybeOldBlobId === void 0) {
        return [];
      } else if (maybeOldBlobId === null) {
        const rows = stmtDeletePartsByKey.all({ object_key: key });
        return rows.map(({ blob_id }) => blob_id);
      } else {
        return [maybeOldBlobId];
      }
    }),
    deleteByKeys: db.transaction((keys) => {
      const oldBlobIds = [];
      for (const key of keys) {
        const row = stmtDelete.get({ key });
        const maybeOldBlobId = row?.blob_id;
        if (maybeOldBlobId === null) {
          const partRows = stmtDeletePartsByKey.all({ object_key: key });
          for (const partRow of partRows)
            oldBlobIds.push(partRow.blob_id);
        } else if (maybeOldBlobId !== void 0) {
          oldBlobIds.push(maybeOldBlobId);
        }
      }
      return oldBlobIds;
    }),
    listWithoutDelimiter: stmtListWithoutDelimiter(),
    listHttpMetadataWithoutDelimiter: stmtListWithoutDelimiter("http_metadata"),
    listCustomMetadataWithoutDelimiter: stmtListWithoutDelimiter("custom_metadata"),
    listHttpCustomMetadataWithoutDelimiter: stmtListWithoutDelimiter(
      "http_metadata",
      "custom_metadata"
    ),
    listMetadata: db.prepare(`
      SELECT
        -- When grouping by a delimited prefix, this will give us the last key with that prefix.
        --   NOTE: we'll use this for the next cursor. If we didn't return the last key, the next page may return the
        --   same delimited prefix. Essentially, we're skipping over all keys with this group's delimited prefix.
        -- When grouping by a key, this will just give us the key.
        max(key) AS last_key,
        iif(
            -- Try get 1-indexed position \`i\` of :delimiter in rest of key after :prefix...
                                                       instr(substr(key, length(:prefix) + 1), :delimiter),
            -- ...if found, we have a delimited prefix of the :prefix followed by the rest of key up to and including the :delimiter
            'dlp:' || substr(key, 1, length(:prefix) + instr(substr(key, length(:prefix) + 1), :delimiter) + length(:delimiter) - 1),
            -- ...otherwise, we just have a regular key
            'key:' || key
        ) AS delimited_prefix_or_key,
        -- NOTE: we'll ignore metadata for delimited prefix rows, so it doesn't matter which keys' we return
        version, size, etag, uploaded, checksums, http_metadata, custom_metadata
      FROM _mf_objects
      WHERE key LIKE :escaped_prefix || '%' ESCAPE '\\'
      AND (:start_after IS NULL OR key > :start_after)
      GROUP BY delimited_prefix_or_key -- Group keys with same delimited prefix into a row, leaving otherS in their own rows
      ORDER BY last_key LIMIT :limit;
    `),
    createMultipartUpload: db.prepare(`
      INSERT INTO _mf_multipart_uploads (upload_id, key, http_metadata, custom_metadata)
      VALUES (:upload_id, :key, :http_metadata, :custom_metadata)
    `),
    putPart: db.transaction(
      (key, newRow) => {
        const uploadRow = stmtGetUploadState.get({
          key,
          upload_id: newRow.upload_id
        });
        if (uploadRow?.state !== MultipartUploadState.IN_PROGRESS) {
          throw new NoSuchUpload();
        }
        const partRow = stmtGetPreviousPartByNumber.get({
          upload_id: newRow.upload_id,
          part_number: newRow.part_number
        });
        stmtPutPart.run(newRow);
        return partRow?.blob_id;
      }
    ),
    completeMultipartUpload: db.transaction(
      (key, upload_id, selectedParts) => {
        const uploadRow = stmtGetUploadMetadata.get({ key, upload_id });
        if (uploadRow === void 0) {
          throw new InternalError();
        } else if (uploadRow.state > MultipartUploadState.IN_PROGRESS) {
          throw new NoSuchUpload();
        }
        const partNumberSet = /* @__PURE__ */ new Set();
        for (const { part } of selectedParts) {
          if (partNumberSet.has(part))
            throw new InternalError();
          partNumberSet.add(part);
        }
        const uploadedPartRows = stmtListPartsByUploadId.all({ upload_id });
        const uploadedParts = /* @__PURE__ */ new Map();
        for (const row of uploadedPartRows) {
          uploadedParts.set(row.part_number, row);
        }
        const parts = selectedParts.map((selectedPart) => {
          const uploadedPart = uploadedParts.get(selectedPart.part);
          if (uploadedPart?.etag !== selectedPart.etag) {
            throw new InvalidPart();
          }
          return uploadedPart;
        });
        for (const part of parts.slice(0, -1)) {
          if (part.size < R2Gateway._MIN_MULTIPART_PART_SIZE) {
            throw new EntityTooSmall();
          }
        }
        parts.sort((a, b) => a.part_number - b.part_number);
        let partSize;
        for (const part of parts.slice(0, -1)) {
          partSize ??= part.size;
          if (part.size < R2Gateway._MIN_MULTIPART_PART_SIZE || part.size !== partSize) {
            throw new BadUpload();
          }
        }
        if (partSize !== void 0 && parts[parts.length - 1].size > partSize) {
          throw new BadUpload();
        }
        const oldBlobIds = [];
        const existingRow = stmtGetPreviousByKey.get({ key });
        const maybeOldBlobId = existingRow?.blob_id;
        if (maybeOldBlobId === null) {
          const partRows2 = stmtDeletePartsByKey.all({ object_key: key });
          for (const partRow of partRows2)
            oldBlobIds.push(partRow.blob_id);
        } else if (maybeOldBlobId !== void 0) {
          oldBlobIds.push(maybeOldBlobId);
        }
        const totalSize = parts.reduce((acc, { size }) => acc + size, 0);
        const etag = generateMultipartEtag(
          parts.map(({ checksum_md5 }) => checksum_md5)
        );
        const newRow = {
          key,
          blob_id: null,
          version: generateVersion(),
          size: totalSize,
          etag,
          uploaded: Date.now(),
          checksums: "{}",
          http_metadata: uploadRow.http_metadata,
          custom_metadata: uploadRow.custom_metadata
        };
        stmtPut.run(newRow);
        for (const part of parts) {
          stmtLinkPart.run({
            upload_id,
            part_number: part.part_number,
            object_key: key
          });
        }
        const partRows = stmtDeleteUnlinkedPartsByUploadId.all({ upload_id });
        for (const partRow of partRows)
          oldBlobIds.push(partRow.blob_id);
        stmtUpdateUploadState.run({
          upload_id,
          state: MultipartUploadState.COMPLETED
        });
        return { newRow, oldBlobIds };
      }
    ),
    abortMultipartUpload: db.transaction((key, upload_id) => {
      const uploadRow = stmtGetUploadState.get({ key, upload_id });
      if (uploadRow === void 0) {
        throw new InternalError();
      } else if (uploadRow.state > MultipartUploadState.IN_PROGRESS) {
        return [];
      }
      const partRows = stmtDeletePartsByUploadId.all({ upload_id });
      const oldBlobIds = partRows.map(({ blob_id }) => blob_id);
      stmtUpdateUploadState.run({
        upload_id,
        state: MultipartUploadState.ABORTED
      });
      return oldBlobIds;
    })
  };
}
var _storage, _stmts, _inUseBlobs, _acquireBlob, acquireBlob_fn, _releaseBlob, releaseBlob_fn, _backgroundDelete, backgroundDelete_fn, _assembleMultipartValue, assembleMultipartValue_fn, _listWithoutDelimiterQuery, listWithoutDelimiterQuery_fn;
var R2Gateway = class {
  constructor(log, storage, timers) {
    this.log = log;
    this.timers = timers;
    __privateAdd(this, _acquireBlob);
    __privateAdd(this, _releaseBlob);
    __privateAdd(this, _backgroundDelete);
    __privateAdd(this, _assembleMultipartValue);
    __privateAdd(this, _listWithoutDelimiterQuery);
    __privateAdd(this, _storage, void 0);
    __privateAdd(this, _stmts, void 0);
    // Multipart uploads are stored as multiple blobs. Therefore, when reading a
    // multipart upload, we'll be reading multiple blobs. When an object is
    // deleted, all its blobs are deleted in the background.
    //
    // Normally for single part objects, this is fine, since we'd open a handle to
    // a single blob, which we'd have until we closed it, at which point the blob
    // may be deleted. With multipart, we don't want to open handles for all blobs
    // as we could hit open file descriptor limits. Similarly, we don't want to
    // read all blobs first, as we'd have to buffer them.
    //
    // Instead, we set up in-process locking on blobs needed for multipart reads.
    // When we start a multipart read, we acquire all the blobs we need, then
    // release them as we've streamed each part. Multiple multipart reads may be
    // in-progress at any given time, so we use a wait group.
    //
    // This assumes we only ever have a single Miniflare instance operating on a
    // blob store, which is always true for in-memory stores, and usually true for
    // on-disk ones. If we really wanted to do this properly, we could store the
    // bookkeeping for the wait group in SQLite, but then we'd have to implement
    // some inter-process signalling/subscription system.
    __privateAdd(this, _inUseBlobs, /* @__PURE__ */ new Map());
    __privateSet(this, _storage, storage);
    __privateGet(this, _storage).db.pragma("case_sensitive_like = TRUE");
    __privateGet(this, _storage).db.exec(SQL_SCHEMA2);
    __privateSet(this, _stmts, sqlStmts2(__privateGet(this, _storage).db));
  }
  async head(key) {
    validate.key(key);
    const row = __privateGet(this, _stmts).getByKey.get({ key });
    if (row === void 0)
      throw new NoSuchKey();
    const range = { offset: 0, length: row.size };
    return new InternalR2Object(row, range);
  }
  async get(key, options = {}) {
    validate.key(key);
    const result = __privateGet(this, _stmts).getPartsByKey(key);
    if (result === void 0)
      throw new NoSuchKey();
    const { row, parts } = result;
    const defaultR2Range = { offset: 0, length: row.size };
    try {
      validate.condition(row, options.onlyIf);
    } catch (e) {
      if (e instanceof PreconditionFailed) {
        e.attach(new InternalR2Object(row, defaultR2Range));
      }
      throw e;
    }
    const range = validate.range(options, row.size);
    let r2Range;
    if (range === void 0) {
      r2Range = defaultR2Range;
    } else {
      const start = range.start;
      const end = Math.min(range.end, row.size);
      r2Range = { offset: start, length: end - start + 1 };
    }
    let value;
    if (row.blob_id === null) {
      (0, import_assert19.default)(parts !== void 0);
      const defaultRange = { start: 0, end: row.size - 1 };
      value = __privateMethod(this, _assembleMultipartValue, assembleMultipartValue_fn).call(this, __privateGet(this, _storage), parts, range ?? defaultRange);
    } else {
      value = await __privateGet(this, _storage).blob.get(row.blob_id, range);
      if (value === null)
        throw new NoSuchKey();
    }
    return new InternalR2ObjectBody(row, value, r2Range);
  }
  async put(key, value, valueSize, options) {
    const algorithms = [];
    for (const { field } of R2_HASH_ALGORITHMS) {
      if (field === "md5" || field in options)
        algorithms.push(field);
    }
    const digesting = new DigestingStream(algorithms);
    const blobId = await __privateGet(this, _storage).blob.put(value.pipeThrough(digesting));
    const digests = await digesting.digests;
    const md5Digest = digests.get("md5");
    (0, import_assert19.default)(md5Digest !== void 0);
    const md5DigestHex = md5Digest.toString("hex");
    const checksums = validate.key(key).size(valueSize).metadataSize(options.customMetadata).hash(digests, options);
    const row = {
      key,
      blob_id: blobId,
      version: generateVersion(),
      size: valueSize,
      etag: md5DigestHex,
      uploaded: Date.now(),
      checksums: JSON.stringify(checksums),
      http_metadata: JSON.stringify(options.httpMetadata ?? {}),
      custom_metadata: JSON.stringify(options.customMetadata ?? {})
    };
    let oldBlobIds;
    try {
      oldBlobIds = __privateGet(this, _stmts).put(row, options.onlyIf);
    } catch (e) {
      __privateMethod(this, _backgroundDelete, backgroundDelete_fn).call(this, blobId);
      throw e;
    }
    if (oldBlobIds !== void 0) {
      for (const blobId2 of oldBlobIds)
        __privateMethod(this, _backgroundDelete, backgroundDelete_fn).call(this, blobId2);
    }
    return new InternalR2Object(row);
  }
  async delete(keys) {
    if (!Array.isArray(keys))
      keys = [keys];
    for (const key of keys)
      validate.key(key);
    const oldBlobIds = __privateGet(this, _stmts).deleteByKeys(keys);
    for (const blobId of oldBlobIds)
      __privateMethod(this, _backgroundDelete, backgroundDelete_fn).call(this, blobId);
  }
  async list(opts = {}) {
    const prefix = opts.prefix ?? "";
    let limit = opts.limit ?? MAX_LIST_KEYS2;
    validate.limit(limit);
    const include = opts.include ?? [];
    if (include.length > 0)
      limit = Math.min(limit, 100);
    const excludeHttp = !include.includes("httpMetadata");
    const excludeCustom = !include.includes("customMetadata");
    const rowObject = (row) => {
      if (row.http_metadata === void 0 || excludeHttp) {
        row.http_metadata = "{}";
      }
      if (row.custom_metadata === void 0 || excludeCustom) {
        row.custom_metadata = "{}";
      }
      return new InternalR2Object(row);
    };
    let startAfter = opts.startAfter;
    if (opts.cursor !== void 0) {
      const cursorStartAfter = base64Decode(opts.cursor);
      if (startAfter === void 0 || cursorStartAfter > startAfter) {
        startAfter = cursorStartAfter;
      }
    }
    let delimiter = opts.delimiter;
    if (delimiter === "")
      delimiter = void 0;
    const params = {
      escaped_prefix: escapeLike(prefix),
      start_after: startAfter ?? null,
      // Increase the queried limit by 1, if we return this many results, we
      // know there are more rows. We'll truncate to the original limit before
      // returning results.
      limit: limit + 1
    };
    let objects;
    const delimitedPrefixes = [];
    let nextCursorStartAfter;
    if (delimiter !== void 0) {
      const rows = __privateGet(this, _stmts).listMetadata.all({
        ...params,
        prefix,
        delimiter
      });
      const hasMoreRows = rows.length === limit + 1;
      rows.splice(limit, 1);
      objects = [];
      for (const row of rows) {
        if (row.delimited_prefix_or_key.startsWith("dlp:")) {
          delimitedPrefixes.push(row.delimited_prefix_or_key.substring(4));
        } else {
          objects.push(rowObject({ ...row, key: row.last_key }));
        }
      }
      if (hasMoreRows)
        nextCursorStartAfter = rows[limit - 1].last_key;
    } else {
      const query = __privateMethod(this, _listWithoutDelimiterQuery, listWithoutDelimiterQuery_fn).call(this, excludeHttp, excludeCustom);
      const rows = query.all(params);
      const hasMoreRows = rows.length === limit + 1;
      rows.splice(limit, 1);
      objects = rows.map(rowObject);
      if (hasMoreRows)
        nextCursorStartAfter = rows[limit - 1].key;
    }
    const nextCursor = maybeApply(base64Encode, nextCursorStartAfter);
    return {
      objects,
      truncated: nextCursor !== void 0,
      cursor: nextCursor,
      delimitedPrefixes
    };
  }
  async createMultipartUpload(key, opts) {
    validate.key(key);
    const uploadId = generateId();
    __privateGet(this, _stmts).createMultipartUpload.run({
      key,
      upload_id: uploadId,
      http_metadata: JSON.stringify(opts.httpMetadata ?? {}),
      custom_metadata: JSON.stringify(opts.customMetadata ?? {})
    });
    return { uploadId };
  }
  async uploadPart(key, uploadId, partNumber, value, valueSize) {
    validate.key(key);
    const digesting = new DigestingStream(["md5"]);
    const blobId = await __privateGet(this, _storage).blob.put(value.pipeThrough(digesting));
    const digests = await digesting.digests;
    const md5Digest = digests.get("md5");
    (0, import_assert19.default)(md5Digest !== void 0);
    const etag = generateId();
    let maybeOldBlobId;
    try {
      maybeOldBlobId = __privateGet(this, _stmts).putPart(key, {
        upload_id: uploadId,
        part_number: partNumber,
        blob_id: blobId,
        size: valueSize,
        etag,
        checksum_md5: md5Digest.toString("hex")
      });
    } catch (e) {
      __privateMethod(this, _backgroundDelete, backgroundDelete_fn).call(this, blobId);
      throw e;
    }
    if (maybeOldBlobId !== void 0)
      __privateMethod(this, _backgroundDelete, backgroundDelete_fn).call(this, maybeOldBlobId);
    return { etag };
  }
  async completeMultipartUpload(key, uploadId, parts) {
    validate.key(key);
    const { newRow, oldBlobIds } = __privateGet(this, _stmts).completeMultipartUpload(
      key,
      uploadId,
      parts
    );
    for (const blobId of oldBlobIds)
      __privateMethod(this, _backgroundDelete, backgroundDelete_fn).call(this, blobId);
    return new InternalR2Object(newRow);
  }
  async abortMultipartUpload(key, uploadId) {
    validate.key(key);
    const oldBlobIds = __privateGet(this, _stmts).abortMultipartUpload(key, uploadId);
    for (const blobId of oldBlobIds)
      __privateMethod(this, _backgroundDelete, backgroundDelete_fn).call(this, blobId);
  }
};
_storage = new WeakMap();
_stmts = new WeakMap();
_inUseBlobs = new WeakMap();
_acquireBlob = new WeakSet();
acquireBlob_fn = function(blobId) {
  let waitGroup = __privateGet(this, _inUseBlobs).get(blobId);
  if (waitGroup === void 0) {
    waitGroup = new WaitGroup();
    __privateGet(this, _inUseBlobs).set(blobId, waitGroup);
    waitGroup.add();
    waitGroup.wait().then(() => __privateGet(this, _inUseBlobs).delete(blobId));
  } else {
    waitGroup.add();
  }
};
_releaseBlob = new WeakSet();
releaseBlob_fn = function(blobId) {
  __privateGet(this, _inUseBlobs).get(blobId)?.done();
};
_backgroundDelete = new WeakSet();
backgroundDelete_fn = function(blobId) {
  this.timers.queueMicrotask(async () => {
    await __privateGet(this, _inUseBlobs).get(blobId)?.wait();
    return __privateGet(this, _storage).blob.delete(blobId).catch((e) => {
      this.log.error(prefixError("Deleting Blob", e));
    });
  });
};
_assembleMultipartValue = new WeakSet();
assembleMultipartValue_fn = function(storage, parts, queryRange) {
  const requiredParts = [];
  let start = 0;
  for (const part of parts) {
    const partRange = { start, end: start + part.size - 1 };
    if (rangeOverlaps(partRange, queryRange)) {
      const range = {
        start: Math.max(partRange.start, queryRange.start) - partRange.start,
        end: Math.min(partRange.end, queryRange.end) - partRange.start
      };
      __privateMethod(this, _acquireBlob, acquireBlob_fn).call(this, part.blob_id);
      requiredParts.push({ blobId: part.blob_id, range });
    }
    start = partRange.end + 1;
  }
  const identity2 = new import_web10.TransformStream();
  (async () => {
    let i = 0;
    try {
      for (; i < requiredParts.length; i++) {
        const { blobId, range } = requiredParts[i];
        const value = await storage.blob.get(blobId, range);
        const msg = `Expected to find blob "${blobId}" for multipart value`;
        (0, import_assert19.default)(value !== null, msg);
        await value.pipeTo(identity2.writable, { preventClose: true });
        __privateMethod(this, _releaseBlob, releaseBlob_fn).call(this, blobId);
      }
      await identity2.writable.close();
    } catch (e) {
      identity2.writable.abort(e);
    } finally {
      for (; i < requiredParts.length; i++) {
        __privateMethod(this, _releaseBlob, releaseBlob_fn).call(this, requiredParts[i].blobId);
      }
    }
  })();
  return identity2.readable;
};
_listWithoutDelimiterQuery = new WeakSet();
listWithoutDelimiterQuery_fn = function(excludeHttp, excludeCustom) {
  if (excludeHttp && excludeCustom)
    return __privateGet(this, _stmts).listWithoutDelimiter;
  if (excludeHttp)
    return __privateGet(this, _stmts).listCustomMetadataWithoutDelimiter;
  if (excludeCustom)
    return __privateGet(this, _stmts).listHttpMetadataWithoutDelimiter;
  return __privateGet(this, _stmts).listHttpCustomMetadataWithoutDelimiter;
};
// Minimum multipart part upload size is configurable, so we can use smaller
// values in tests
/** @internal */
__publicField(R2Gateway, "_MIN_MULTIPART_PART_SIZE", 5 * 1024 * 1024);

// packages/miniflare/src/plugins/r2/router.ts
var import_assert20 = __toESM(require("assert"));
async function decodeMetadata(req) {
  const metadataSize = Number(req.headers.get("cf-r2-metadata-size" /* MetadataSize */));
  if (Number.isNaN(metadataSize))
    throw new InvalidMetadata();
  (0, import_assert20.default)(req.body !== null);
  const body = req.body;
  const [metadataBuffer, value] = await readPrefix(body, metadataSize);
  const metadataJson = metadataBuffer.toString();
  const metadata = R2BindingRequestSchema.parse(JSON.parse(metadataJson));
  return { metadata, metadataSize, value };
}
function decodeHeaderMetadata(req) {
  const header = req.headers.get("cf-r2-request" /* Request */);
  if (header === null)
    throw new InvalidMetadata();
  return R2BindingRequestSchema.parse(JSON.parse(header));
}
function encodeResult(result) {
  let encoded;
  if (result instanceof InternalR2Object) {
    encoded = result.encode();
  } else {
    encoded = InternalR2Object.encodeMultiple(result);
  }
  return new Response(encoded.value, {
    headers: {
      ["cf-r2-metadata-size" /* MetadataSize */]: `${encoded.metadataSize}`,
      "Content-Type": "application/json"
    }
  });
}
function encodeJSONResult(result) {
  const encoded = JSON.stringify(result);
  return new Response(encoded, {
    headers: {
      ["cf-r2-metadata-size" /* MetadataSize */]: `${Buffer.byteLength(encoded)}`,
      "Content-Type": "application/json"
    }
  });
}
var R2Router = class extends Router {
  get = async (req, params) => {
    const metadata = decodeHeaderMetadata(req);
    const persist = decodePersist(req.headers);
    const bucket = decodeURIComponent(params.bucket);
    const gateway = this.gatewayFactory.get(bucket, persist);
    let result;
    if (metadata.method === "head") {
      result = await gateway.head(metadata.object);
    } else if (metadata.method === "get") {
      result = await gateway.get(metadata.object, metadata);
    } else if (metadata.method === "list") {
      result = await gateway.list(metadata);
    } else {
      throw new InternalError();
    }
    return encodeResult(result);
  };
  put = async (req, params) => {
    const { metadata, metadataSize, value } = await decodeMetadata(req);
    const persist = decodePersist(req.headers);
    const bucket = decodeURIComponent(params.bucket);
    const gateway = this.gatewayFactory.get(bucket, persist);
    if (metadata.method === "delete") {
      await gateway.delete(
        "object" in metadata ? metadata.object : metadata.objects
      );
      return new Response();
    } else if (metadata.method === "put") {
      const contentLength = Number(req.headers.get("Content-Length"));
      (0, import_assert20.default)(!isNaN(contentLength));
      const valueSize = contentLength - metadataSize;
      const result = await gateway.put(
        metadata.object,
        value,
        valueSize,
        metadata
      );
      return encodeResult(result);
    } else if (metadata.method === "createMultipartUpload") {
      const result = await gateway.createMultipartUpload(
        metadata.object,
        metadata
      );
      return encodeJSONResult(result);
    } else if (metadata.method === "uploadPart") {
      const contentLength = Number(req.headers.get("Content-Length"));
      (0, import_assert20.default)(!isNaN(contentLength));
      const valueSize = contentLength - metadataSize;
      const result = await gateway.uploadPart(
        metadata.object,
        metadata.uploadId,
        metadata.partNumber,
        value,
        valueSize
      );
      return encodeJSONResult(result);
    } else if (metadata.method === "completeMultipartUpload") {
      const result = await gateway.completeMultipartUpload(
        metadata.object,
        metadata.uploadId,
        metadata.parts
      );
      return encodeResult(result);
    } else if (metadata.method === "abortMultipartUpload") {
      await gateway.abortMultipartUpload(metadata.object, metadata.uploadId);
      return new Response();
    } else {
      throw new InternalError();
    }
  };
};
__decorateClass([
  GET("/:bucket")
], R2Router.prototype, "get", 2);
__decorateClass([
  PUT("/:bucket")
], R2Router.prototype, "put", 2);

// packages/miniflare/src/plugins/r2/index.ts
var R2OptionsSchema = import_zod20.z.object({
  r2Buckets: import_zod20.z.union([import_zod20.z.record(import_zod20.z.string()), import_zod20.z.string().array()]).optional()
});
var R2SharedOptionsSchema = import_zod20.z.object({
  r2Persist: PersistenceSchema
});
var R2_PLUGIN_NAME = "r2";
var R2_PLUGIN = {
  gateway: R2Gateway,
  router: R2Router,
  options: R2OptionsSchema,
  sharedOptions: R2SharedOptionsSchema,
  getBindings(options) {
    const buckets = namespaceEntries(options.r2Buckets);
    return buckets.map(([name, id]) => ({
      name,
      r2Bucket: { name: `${R2_PLUGIN_NAME}:${id}` }
    }));
  },
  getNodeBindings(options) {
    const buckets = namespaceKeys(options.r2Buckets);
    return Object.fromEntries(buckets.map((name) => [name, kProxyNodeBinding]));
  },
  getServices({ options, sharedOptions }) {
    const persist = sharedOptions.r2Persist;
    const buckets = namespaceEntries(options.r2Buckets);
    return buckets.map(([_, id]) => ({
      name: `${R2_PLUGIN_NAME}:${id}`,
      worker: pluginNamespacePersistWorker(
        R2_PLUGIN_NAME,
        encodeURIComponent(id),
        persist
      )
    }));
  }
};

// packages/miniflare/src/plugins/index.ts
var PLUGINS = {
  [CORE_PLUGIN_NAME2]: CORE_PLUGIN,
  [CACHE_PLUGIN_NAME]: CACHE_PLUGIN,
  [D1_PLUGIN_NAME]: D1_PLUGIN,
  [DURABLE_OBJECTS_PLUGIN_NAME]: DURABLE_OBJECTS_PLUGIN,
  [KV_PLUGIN_NAME]: KV_PLUGIN,
  [QUEUES_PLUGIN_NAME]: QUEUES_PLUGIN,
  [R2_PLUGIN_NAME]: R2_PLUGIN
};
var PLUGIN_ENTRIES = Object.entries(PLUGINS);

// packages/miniflare/src/http/cert.ts
var KEY = `
-----BEGIN EC PRIVATE KEY-----
MHcCAQEEIC+umAaVUbEfPqGA9M7b5zAP7tN2eLT1bu8U8gpbaKbsoAoGCCqGSM49
AwEHoUQDQgAEtrIEgzogjrUHIvB4qgjg/cT7blhWuLUfSUp6H62NCo21NrVWgPtC
mCWw+vbGTBwIr/9X1S4UL1/f3zDICC7YSA==
-----END EC PRIVATE KEY-----
`;
var CERT = `
-----BEGIN CERTIFICATE-----
MIICcDCCAhegAwIBAgIUE97EcbEWw3YZMN/ucGBSzJ/5qA4wCgYIKoZIzj0EAwIw
VTELMAkGA1UEBhMCVVMxDjAMBgNVBAgMBVRleGFzMQ8wDQYDVQQHDAZBdXN0aW4x
EzARBgNVBAoMCkNsb3VkZmxhcmUxEDAOBgNVBAsMB1dvcmtlcnMwIBcNMjMwNjIy
MTg1ODQ3WhgPMjEyMzA1MjkxODU4NDdaMFUxCzAJBgNVBAYTAlVTMQ4wDAYDVQQI
DAVUZXhhczEPMA0GA1UEBwwGQXVzdGluMRMwEQYDVQQKDApDbG91ZGZsYXJlMRAw
DgYDVQQLDAdXb3JrZXJzMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEtrIEgzog
jrUHIvB4qgjg/cT7blhWuLUfSUp6H62NCo21NrVWgPtCmCWw+vbGTBwIr/9X1S4U
L1/f3zDICC7YSKOBwjCBvzAdBgNVHQ4EFgQUSXahTksi00c6KhUECHIY4FLW7Sow
HwYDVR0jBBgwFoAUSXahTksi00c6KhUECHIY4FLW7SowDwYDVR0TAQH/BAUwAwEB
/zAsBglghkgBhvhCAQ0EHxYdT3BlblNTTCBHZW5lcmF0ZWQgQ2VydGlmaWNhdGUw
CwYDVR0PBAQDAgL0MDEGA1UdJQQqMCgGCCsGAQUFBwMBBggrBgEFBQcDAgYIKwYB
BQUHAwMGCCsGAQUFBwMIMAoGCCqGSM49BAMCA0cAMEQCIE2qnXbKTHQ8wtwI+9XR
h4ivDyz7w7iGxn3+ccmj/CQqAiApdX/Iz/jGRzi04xFlE4GoPVG/zaMi64ckmIpE
ez/dHA==
-----END CERTIFICATE-----
`;

// packages/miniflare/src/http/server.ts
async function configureEntrySocket(coreOpts) {
  const httpOptions = {
    // Even though we inject a `cf` object in the entry worker, allow it to
    // be customised via `dispatchFetch`
    cfBlobHeader: HEADER_CF_BLOB
  };
  let privateKey = void 0;
  let certificateChain = void 0;
  if ((coreOpts.httpsKey || coreOpts.httpsKeyPath) && (coreOpts.httpsCert || coreOpts.httpsCertPath)) {
    privateKey = await valueOrFile(coreOpts.httpsKey, coreOpts.httpsKeyPath);
    certificateChain = await valueOrFile(
      coreOpts.httpsCert,
      coreOpts.httpsCertPath
    );
  } else if (coreOpts.https) {
    privateKey = KEY;
    certificateChain = CERT;
  }
  let options;
  if (privateKey && certificateChain) {
    options = {
      https: {
        options: httpOptions,
        tlsOptions: {
          keypair: {
            privateKey,
            certificateChain
          }
        }
      }
    };
  } else {
    options = {
      http: httpOptions
    };
  }
  return {
    name: SOCKET_ENTRY,
    service: { name: SERVICE_ENTRY },
    ...options
  };
}
function valueOrFile(value, filePath) {
  return value ?? (filePath && import_promises8.default.readFile(filePath, "utf8"));
}

// packages/miniflare/src/http/helpers.ts
var import_os2 = require("os");
function getAccessibleHosts(ipv4Only = false) {
  const hosts = [];
  Object.values((0, import_os2.networkInterfaces)()).forEach((net2) => {
    net2?.forEach(({ family, address }) => {
      if (family === "IPv4" || family === 4) {
        hosts.push(address);
      } else if (!ipv4Only && (family === "IPv6" || family === 6)) {
        hosts.push(`[${address}]`);
      }
    });
  });
  return hosts;
}

// packages/miniflare/src/http/index.ts
var import_undici8 = require("undici");

// packages/miniflare/src/index.ts
function validateOptions(opts) {
  const sharedOpts = opts;
  const multipleWorkers = "workers" in opts;
  const workerOpts = multipleWorkers ? opts.workers : [opts];
  if (workerOpts.length === 0) {
    throw new MiniflareCoreError("ERR_NO_WORKERS", "No workers defined");
  }
  const pluginSharedOpts = {};
  const pluginWorkerOpts = Array.from(Array(workerOpts.length)).map(
    () => ({})
  );
  for (const [key, plugin] of PLUGIN_ENTRIES) {
    pluginSharedOpts[key] = plugin.sharedOptions?.parse(sharedOpts);
    for (let i = 0; i < workerOpts.length; i++) {
      const path14 = multipleWorkers ? ["workers", i] : void 0;
      pluginWorkerOpts[i][key] = plugin.options.parse(workerOpts[i], { path: path14 });
    }
  }
  const names = /* @__PURE__ */ new Set();
  for (const opts2 of pluginWorkerOpts) {
    const name = opts2.core.name ?? "";
    if (names.has(name)) {
      throw new MiniflareCoreError(
        "ERR_DUPLICATE_NAME",
        name === "" ? "Multiple workers defined without a `name`" : `Multiple workers defined with the same \`name\`: "${name}"`
      );
    }
    names.add(name);
  }
  return [pluginSharedOpts, pluginWorkerOpts];
}
function getDurableObjectClassNames(allWorkerOpts) {
  const serviceClassNames = /* @__PURE__ */ new Map();
  for (const workerOpts of allWorkerOpts) {
    const workerServiceName = getUserServiceName(workerOpts.core.name);
    for (const designator of Object.values(
      workerOpts.do.durableObjects ?? {}
    )) {
      const {
        className,
        // Fallback to current worker service if name not defined
        serviceName = workerServiceName,
        unsafeUniqueKey
      } = normaliseDurableObject(designator);
      let classNames = serviceClassNames.get(serviceName);
      if (classNames === void 0) {
        classNames = /* @__PURE__ */ new Map();
        serviceClassNames.set(serviceName, classNames);
      }
      if (classNames.has(className)) {
        const existingUnsafeUniqueKey = classNames.get(className);
        if (existingUnsafeUniqueKey !== unsafeUniqueKey) {
          throw new MiniflareCoreError(
            "ERR_DIFFERENT_UNIQUE_KEYS",
            `Multiple unsafe unique keys defined for Durable Object "${className}" in "${serviceName}": ${JSON.stringify(
              unsafeUniqueKey
            )} and ${JSON.stringify(existingUnsafeUniqueKey)}`
          );
        }
      } else {
        classNames.set(className, unsafeUniqueKey);
      }
    }
  }
  return serviceClassNames;
}
function getQueueConsumers(allWorkerOpts) {
  const queueConsumers = /* @__PURE__ */ new Map();
  for (const workerOpts of allWorkerOpts) {
    const workerName = workerOpts.core.name ?? "";
    let workerConsumers = workerOpts.queues.queueConsumers;
    if (workerConsumers !== void 0) {
      if (Array.isArray(workerConsumers)) {
        workerConsumers = Object.fromEntries(
          workerConsumers.map((queueName) => [queueName, {}])
        );
      }
      for (const [queueName, opts] of Object.entries(workerConsumers)) {
        const existingConsumer = queueConsumers.get(queueName);
        if (existingConsumer !== void 0) {
          throw new QueuesError(
            "ERR_MULTIPLE_CONSUMERS",
            `Multiple consumers defined for queue "${queueName}": "${existingConsumer.workerName}" and "${workerName}"`
          );
        }
        queueConsumers.set(queueName, { workerName, ...opts });
      }
    }
  }
  for (const [queueName, consumer] of queueConsumers) {
    if (consumer.deadLetterQueue !== void 0) {
      if (consumer.deadLetterQueue === queueName) {
        throw new QueuesError(
          "ERR_DEAD_LETTER_QUEUE_CYCLE",
          `Dead letter queue for queue "${queueName}" cannot be itself`
        );
      }
      consumer.deadLetterConsumer = queueConsumers.get(
        consumer.deadLetterQueue
      );
    }
  }
  return queueConsumers;
}
function getWorkerRoutes(allWorkerOpts) {
  const allRoutes = /* @__PURE__ */ new Map();
  for (const workerOpts of allWorkerOpts) {
    const name = workerOpts.core.name ?? "";
    (0, import_assert21.default)(!allRoutes.has(name));
    allRoutes.set(name, workerOpts.core.routes ?? []);
  }
  return allRoutes;
}
function getProxyBindingName(plugin, worker, binding) {
  return [
    CoreBindings.DURABLE_OBJECT_NAMESPACE_PROXY,
    plugin,
    worker,
    binding
  ].join(":");
}
function isNativeTargetBinding(binding) {
  return !("json" in binding || "wasmModule" in binding || "text" in binding || "data" in binding);
}
function buildProxyBinding(plugin, worker, binding) {
  (0, import_assert21.default)(binding.name !== void 0);
  const name = getProxyBindingName(plugin, worker, binding.name);
  const proxyBinding = { ...binding, name };
  if ("durableObjectNamespace" in proxyBinding && proxyBinding.durableObjectNamespace !== void 0) {
    proxyBinding.durableObjectNamespace.serviceName ??= getUserServiceName(worker);
  }
  return proxyBinding;
}
var restrictedUndiciHeaders = [
  // From Miniflare 2:
  // https://github.com/cloudflare/miniflare/blob/9c135599dc21fe69080ada17fce6153692793bf1/packages/core/src/standards/http.ts#L129-L132
  "transfer-encoding",
  "connection",
  "keep-alive",
  "expect"
];
var restrictedWebSocketUpgradeHeaders = [
  "upgrade",
  "connection",
  "sec-websocket-accept"
];
function _transformsForContentEncoding(encoding) {
  const encoders = [];
  if (!encoding)
    return encoders;
  const codings = encoding.toLowerCase().split(",").map((x) => x.trim());
  for (const coding of codings) {
    if (/(x-)?gzip/.test(coding)) {
      encoders.push(import_zlib.default.createGzip());
    } else if (/(x-)?deflate/.test(coding)) {
      encoders.push(import_zlib.default.createDeflate());
    } else if (coding === "br") {
      encoders.push(import_zlib.default.createBrotliCompress());
    } else {
      encoders.length = 0;
      break;
    }
  }
  return encoders;
}
async function writeResponse(response, res) {
  const headers = {};
  for (const entry of response.headers) {
    const key = entry[0].toLowerCase();
    const value = entry[1];
    if (key === "set-cookie") {
      headers[key] = response.headers.getSetCookie();
    } else {
      headers[key] = value;
    }
  }
  const encoding = headers["content-encoding"]?.toString();
  const encoders = _transformsForContentEncoding(encoding);
  if (encoders.length > 0) {
    delete headers["content-length"];
  }
  res.writeHead(response.status, response.statusText, headers);
  let initialStream = res;
  for (let i = encoders.length - 1; i >= 0; i--) {
    encoders[i].pipe(initialStream);
    initialStream = encoders[i];
  }
  if (response.body) {
    for await (const chunk of response.body) {
      if (chunk)
        initialStream.write(chunk);
    }
  }
  initialStream.end();
}
function safeReadableStreamFrom(iterable) {
  let iterator;
  return new import_web11.ReadableStream(
    {
      async start() {
        iterator = iterable[Symbol.asyncIterator]();
      },
      // @ts-expect-error `pull` may return anything
      async pull(controller) {
        try {
          const { done, value } = await iterator.next();
          if (done) {
            queueMicrotask(() => controller.close());
          } else {
            const buf = Buffer.isBuffer(value) ? value : Buffer.from(value);
            controller.enqueue(new Uint8Array(buf));
          }
        } catch {
          queueMicrotask(() => controller.close());
        }
        return controller.desiredSize > 0;
      },
      async cancel() {
        await iterator.return?.();
      }
    },
    0
  );
}
var maybeInstanceRegistry;
function _initialiseInstanceRegistry() {
  return maybeInstanceRegistry = /* @__PURE__ */ new Map();
}
var Miniflare = class {
  #gatewayFactories;
  #routers;
  #sharedOpts;
  #workerOpts;
  #log;
  #timers;
  #host;
  #accessibleHost;
  #runtime;
  #removeRuntimeExitHook;
  #runtimeEntryURL;
  #proxyClient;
  #sourceMapRegistry;
  // Path to temporary directory for use as scratch space/"in-memory" Durable
  // Object storage. Note this may not exist, it's up to the consumers to
  // create this if needed. Deleted on `dispose()`.
  #tmpPath;
  #removeTmpPathExitHook;
  // Mutual exclusion lock for runtime operations (i.e. initialisation and
  // updating config). This essentially puts initialisation and future updates
  // in a queue, ensuring they're performed in calling order.
  #runtimeMutex;
  // Store `#init()` `Promise`, so we can propagate initialisation errors in
  // `ready`. We would have no way of catching these otherwise.
  #initPromise;
  // Aborted when dispose() is called
  #disposeController;
  #loopbackServer;
  #loopbackPort;
  #liveReloadServer;
  #webSocketServer;
  #webSocketExtraHeaders;
  constructor(opts) {
    this.#gatewayFactories = {};
    this.#routers = {};
    const [sharedOpts, workerOpts] = validateOptions(opts);
    this.#sharedOpts = sharedOpts;
    this.#workerOpts = workerOpts;
    if (maybeInstanceRegistry !== void 0) {
      const object = { name: "Miniflare", stack: "" };
      Error.captureStackTrace(object, Miniflare);
      maybeInstanceRegistry.set(this, object.stack);
    }
    this.#log = this.#sharedOpts.core.log ?? new NoOpLog();
    this.#timers = this.#sharedOpts.core.timers ?? defaultTimers;
    this.#host = this.#sharedOpts.core.host ?? "127.0.0.1";
    this.#accessibleHost = this.#host === "*" || this.#host === "0.0.0.0" || this.#host === "::" ? "127.0.0.1" : this.#host;
    if (import_net.default.isIPv6(this.#accessibleHost)) {
      this.#accessibleHost = `[${this.#accessibleHost}]`;
    }
    this.#initPlugins();
    this.#liveReloadServer = new import_ws3.WebSocketServer({ noServer: true });
    this.#webSocketServer = new import_ws3.WebSocketServer({
      noServer: true,
      // Disable automatic handling of `Sec-WebSocket-Protocol` header,
      // Cloudflare Workers require users to include this header themselves in
      // `Response`s: https://github.com/cloudflare/miniflare/issues/179
      handleProtocols: () => false
    });
    this.#webSocketExtraHeaders = /* @__PURE__ */ new WeakMap();
    this.#webSocketServer.on("headers", (headers, req) => {
      const extra = this.#webSocketExtraHeaders.get(req);
      this.#webSocketExtraHeaders.delete(req);
      if (extra) {
        for (const [key, value] of extra) {
          if (!restrictedWebSocketUpgradeHeaders.includes(key.toLowerCase())) {
            headers.push(`${key}: ${value}`);
          }
        }
      }
    });
    this.#tmpPath = import_path13.default.join(
      import_os3.default.tmpdir(),
      `miniflare-${import_crypto8.default.randomBytes(16).toString("hex")}`
    );
    this.#removeTmpPathExitHook = (0, import_exit_hook.default)(() => {
      import_fs6.default.rmSync(this.#tmpPath, { force: true, recursive: true });
    });
    this.#disposeController = new AbortController();
    this.#runtimeMutex = new Mutex();
    this.#initPromise = this.#runtimeMutex.runWith(() => this.#init()).catch((e) => {
      maybeInstanceRegistry?.delete(this);
      throw e;
    });
  }
  #initPlugins() {
    for (const [key, plugin] of PLUGIN_ENTRIES) {
      if (plugin.gateway !== void 0 && plugin.router !== void 0) {
        const gatewayFactory = new GatewayFactory(
          this.#log,
          this.#timers,
          this.dispatchFetch,
          key,
          plugin.gateway
        );
        const router = new plugin.router(this.#log, gatewayFactory);
        this.#gatewayFactories[key] = gatewayFactory;
        this.#routers[key] = router;
      }
    }
  }
  #handleReload() {
    for (const ws of this.#liveReloadServer.clients) {
      ws.close(1012, "Service Restart");
    }
    for (const ws of this.#webSocketServer.clients) {
      ws.close(1012, "Service Restart");
    }
  }
  async #init() {
    this.#loopbackServer = await this.#startLoopbackServer(0, this.#host);
    const address = this.#loopbackServer.address();
    (0, import_assert21.default)(address !== null && typeof address === "object");
    this.#loopbackPort = address.port;
    const port = this.#sharedOpts.core.port ?? 0;
    const opts = {
      entryHost: import_net.default.isIPv6(this.#host) ? `[${this.#host}]` : this.#host,
      entryPort: port,
      loopbackPort: this.#loopbackPort,
      inspectorPort: this.#sharedOpts.core.inspectorPort,
      verbose: this.#sharedOpts.core.verbose
    };
    this.#runtime = new Runtime(opts);
    this.#removeRuntimeExitHook = (0, import_exit_hook.default)(() => void this.#runtime?.dispose());
    await this.#assembleAndUpdateConfig();
  }
  async #handleLoopbackCustomService(request, customService) {
    const slashIndex = customService.indexOf("/");
    const workerIndex = parseInt(customService.substring(0, slashIndex));
    const serviceKind = customService[slashIndex + 1];
    const serviceName = customService.substring(slashIndex + 2);
    let service;
    if (serviceKind === "#" /* UNKNOWN */) {
      service = this.#workerOpts[workerIndex]?.core.serviceBindings?.[serviceName];
    } else if (serviceName === CUSTOM_SERVICE_KNOWN_OUTBOUND) {
      service = this.#workerOpts[workerIndex]?.core.outboundService;
    }
    (0, import_assert21.default)(typeof service === "function");
    try {
      const response = await service(request);
      return import_zod21.z.instanceof(Response).parse(response);
    } catch (e) {
      return new Response(e?.stack ?? e, { status: 500 });
    }
  }
  async #handleLoopbackPlugins(request, url) {
    const pathname = url.pathname;
    for (const [key] of PLUGIN_ENTRIES) {
      const pluginPrefix = `/${key}`;
      if (pathname.startsWith(pluginPrefix)) {
        url.pathname = pathname.substring(pluginPrefix.length);
        try {
          const response = await this.#routers[key]?.route(request, url);
          if (response !== void 0)
            return response;
        } catch (e) {
          if (e instanceof HttpError)
            return e.toResponse();
          throw e;
        }
      }
    }
  }
  get #workerSrcOpts() {
    return this.#workerOpts.map(({ core }) => core);
  }
  #handleLoopback = async (req, res) => {
    const headers = new import_undici8.Headers();
    for (const [name, values] of Object.entries(req.headers)) {
      if (restrictedUndiciHeaders.includes(name))
        continue;
      if (Array.isArray(values)) {
        for (const value of values)
          headers.append(name, value);
      } else if (values !== void 0) {
        headers.append(name, values);
      }
    }
    const cfBlob = headers.get(HEADER_CF_BLOB);
    headers.delete(HEADER_CF_BLOB);
    (0, import_assert21.default)(!Array.isArray(cfBlob));
    const cf = cfBlob ? JSON.parse(cfBlob) : void 0;
    const url = new URL(
      headers.get(CoreHeaders.ORIGINAL_URL) ?? req.url ?? "",
      "http://localhost"
    );
    headers.delete(CoreHeaders.ORIGINAL_URL);
    const noBody = req.method === "GET" || req.method === "HEAD";
    const body = noBody ? void 0 : safeReadableStreamFrom(req);
    const request = new Request(url, {
      method: req.method,
      headers,
      body,
      duplex: "half",
      cf
    });
    let response;
    try {
      const customService = request.headers.get(CoreHeaders.CUSTOM_SERVICE);
      if (customService !== null) {
        request.headers.delete(CoreHeaders.CUSTOM_SERVICE);
        response = await this.#handleLoopbackCustomService(
          request,
          customService
        );
      } else if (url.pathname === "/core/error") {
        response = await handlePrettyErrorRequest(
          this.#log,
          this.#workerSrcOpts,
          request
        );
      } else if (url.pathname === "/core/log") {
        const text = await request.text();
        try {
          const info = ResponseInfoSchema.parse(JSON.parse(text));
          this.#log.info(await formatResponse(info));
        } catch (e) {
          this.#log.debug(`Error parsing response log: ${String(e)}`);
        }
        response = new Response(null, { status: 204 });
      } else if (url.pathname.startsWith(SourceMapRegistry.PATHNAME_PREFIX)) {
        response = await this.#sourceMapRegistry?.get(url);
      } else {
        response = await this.#handleLoopbackPlugins(request, url);
      }
    } catch (e) {
      this.#log.error(e);
      res?.writeHead(500);
      res?.end(e?.stack ?? String(e));
      return;
    }
    if (res !== void 0) {
      if (response === void 0) {
        res.writeHead(404);
        res.end();
      } else {
        await writeResponse(response, res);
      }
    }
    return response;
  };
  #handleLoopbackUpgrade = async (req, socket, head) => {
    const { pathname } = new URL(req.url ?? "", "http://localhost");
    if (pathname === "/cdn-cgi/mf/reload") {
      this.#liveReloadServer.handleUpgrade(req, socket, head, (ws) => {
        this.#liveReloadServer.emit("connection", ws, req);
      });
      return;
    }
    const response = await this.#handleLoopback(req);
    const webSocket = response?.webSocket;
    if (response?.status === 101 && webSocket) {
      this.#webSocketExtraHeaders.set(req, response.headers);
      this.#webSocketServer.handleUpgrade(req, socket, head, (ws) => {
        void coupleWebSocket(ws, webSocket);
        this.#webSocketServer.emit("connection", ws, req);
      });
      return;
    }
    const res = new import_http20.default.ServerResponse(req);
    (0, import_assert21.default)(socket instanceof import_net.default.Socket);
    res.assignSocket(socket);
    if (!response || response.ok) {
      res.writeHead(500);
      res.end();
      this.#log.error(
        new TypeError(
          "Web Socket request did not return status 101 Switching Protocols response with Web Socket"
        )
      );
      return;
    }
    await writeResponse(response, res);
  };
  #startLoopbackServer(port, hostname) {
    if (hostname === "*") {
      hostname = "::";
    }
    return new Promise((resolve) => {
      const server = (0, import_stoppable.default)(
        import_http20.default.createServer(this.#handleLoopback),
        /* grace */
        0
      );
      server.on("upgrade", this.#handleLoopbackUpgrade);
      server.listen(port, hostname, () => resolve(server));
    });
  }
  #stopLoopbackServer() {
    return new Promise((resolve, reject) => {
      (0, import_assert21.default)(this.#loopbackServer !== void 0);
      this.#loopbackServer.stop((err2) => err2 ? reject(err2) : resolve());
    });
  }
  async #assembleConfig() {
    const allWorkerOpts = this.#workerOpts;
    const sharedOpts = this.#sharedOpts;
    const loopbackPort = this.#loopbackPort;
    (0, import_assert21.default)(loopbackPort !== void 0);
    sharedOpts.core.cf = await setupCf(this.#log, sharedOpts.core.cf);
    const sourceMapRegistry = new SourceMapRegistry(
      this.#log,
      loopbackPort,
      sharedOpts.core.unsafeSourceMapIgnoreSourcePredicate
    );
    const durableObjectClassNames = getDurableObjectClassNames(allWorkerOpts);
    const queueConsumers = getQueueConsumers(allWorkerOpts);
    const allWorkerRoutes = getWorkerRoutes(allWorkerOpts);
    const services = /* @__PURE__ */ new Map();
    const sockets = [await configureEntrySocket(sharedOpts.core)];
    const proxyBindings = [];
    for (let i = 0; i < allWorkerOpts.length; i++) {
      const workerOpts = allWorkerOpts[i];
      const workerName = workerOpts.core.name ?? "";
      const workerBindings = [];
      const additionalModules = [];
      for (const [key, plugin] of PLUGIN_ENTRIES) {
        const pluginBindings = await plugin.getBindings(workerOpts[key], i);
        if (pluginBindings !== void 0) {
          for (const binding of pluginBindings) {
            workerBindings.push(binding);
            if (isNativeTargetBinding(binding)) {
              proxyBindings.push(buildProxyBinding(key, workerName, binding));
            }
          }
          if (key === "kv") {
            const module2 = maybeGetSitesManifestModule(pluginBindings);
            if (module2 !== void 0)
              additionalModules.push(module2);
          }
        }
      }
      const pluginServicesOptionsBase = {
        log: this.#log,
        workerBindings,
        workerIndex: i,
        additionalModules,
        tmpPath: this.#tmpPath,
        sourceMapRegistry,
        durableObjectClassNames,
        queueConsumers
      };
      for (const [key, plugin] of PLUGIN_ENTRIES) {
        const pluginServices = await plugin.getServices({
          ...pluginServicesOptionsBase,
          // @ts-expect-error `CoreOptionsSchema` has required options which are
          //  missing in other plugins' options.
          options: workerOpts[key],
          // @ts-expect-error `QueuesPlugin` doesn't define shared options
          sharedOptions: sharedOpts[key]
        });
        if (pluginServices !== void 0) {
          for (const service of pluginServices) {
            if (service.name !== void 0 && !services.has(service.name)) {
              services.set(service.name, service);
            }
          }
        }
      }
    }
    const extensions = [
      {
        modules: [
          {
            name: "miniflare-internal:identity",
            internal: true,
            // Not accessible to user code
            esModule: `
            class Identity {
              async asyncIdentity(...args) {
                const i = args.findIndex((arg) => arg instanceof ReadableStream);
                if (i !== -1) args[i] = args[i].pipeThrough(new TransformStream());
                return args;
              }
            }
            export default function() { return new Identity(); }
            `
          }
        ]
      }
    ];
    proxyBindings.push({
      name: "IDENTITY",
      wrapped: { moduleName: "miniflare-internal:identity" }
    });
    const globalServices = getGlobalServices({
      sharedOptions: sharedOpts.core,
      allWorkerRoutes,
      fallbackWorkerName: this.#workerOpts[0].core.name,
      loopbackPort,
      log: this.#log,
      proxyBindings
    });
    for (const service of globalServices) {
      (0, import_assert21.default)(service.name !== void 0 && !services.has(service.name));
      services.set(service.name, service);
    }
    this.#sourceMapRegistry = sourceMapRegistry;
    return { services: Array.from(services.values()), sockets, extensions };
  }
  async #assembleAndUpdateConfig() {
    const initial = !this.#runtimeEntryURL;
    (0, import_assert21.default)(this.#runtime !== void 0);
    const config = await this.#assembleConfig();
    const configBuffer = serializeConfig(config);
    const maybePort = await this.#runtime.updateConfig(configBuffer, {
      signal: this.#disposeController.signal,
      entryPort: maybeApply(parseInt, this.#runtimeEntryURL?.port)
    });
    if (this.#disposeController.signal.aborted)
      return;
    if (maybePort === void 0) {
      throw new MiniflareCoreError(
        "ERR_RUNTIME_FAILURE",
        "The Workers runtime failed to start. There is likely additional logging output above."
      );
    }
    const entrySocket = config.sockets?.[0];
    const secure = entrySocket !== void 0 && "https" in entrySocket;
    this.#runtimeEntryURL = new URL(
      `${secure ? "https" : "http"}://${this.#accessibleHost}:${maybePort}`
    );
    if (this.#proxyClient === void 0) {
      this.#proxyClient = new ProxyClient(
        this.#runtimeEntryURL,
        this.dispatchFetch
      );
    } else {
      this.#proxyClient.poisonProxies(this.#runtimeEntryURL);
    }
    if (!this.#runtimeMutex.hasWaiting) {
      const ready = initial ? "Ready" : "Updated and ready";
      const host = import_net.default.isIPv6(this.#host) ? `[${this.#host}]` : this.#host;
      this.#log.info(
        `${ready} on ${secure ? "https" : "http"}://${host}:${maybePort} `
      );
      let hosts;
      if (this.#host === "::" || this.#host === "*") {
        hosts = getAccessibleHosts(false);
      } else if (this.#host === "0.0.0.0") {
        hosts = getAccessibleHosts(true);
      } else {
        hosts = [];
      }
      for (const h of hosts) {
        this.#log.info(`- ${secure ? "https" : "http"}://${h}:${maybePort}`);
      }
      this.#handleReload();
    }
  }
  async #waitForReady() {
    await this.#initPromise;
    await this.#runtimeMutex.drained();
    (0, import_assert21.default)(this.#runtimeEntryURL !== void 0);
    return new URL(this.#runtimeEntryURL.toString());
  }
  get ready() {
    return this.#waitForReady();
  }
  #checkDisposed() {
    if (this.#disposeController.signal.aborted) {
      throw new MiniflareCoreError(
        "ERR_DISPOSED",
        "Cannot use disposed instance"
      );
    }
  }
  async #setOptions(opts) {
    const [sharedOpts, workerOpts] = validateOptions(opts);
    this.#sharedOpts = sharedOpts;
    this.#workerOpts = workerOpts;
    this.#log = this.#sharedOpts.core.log ?? this.#log;
    await this.#assembleAndUpdateConfig();
  }
  setOptions(opts) {
    this.#checkDisposed();
    return this.#runtimeMutex.runWith(() => this.#setOptions(opts));
  }
  dispatchFetch = async (input, init) => {
    this.#checkDisposed();
    await this.ready;
    const forward = new Request(input, init);
    const url = new URL(forward.url);
    forward.headers.set(CoreHeaders.ORIGINAL_URL, url.toString());
    url.protocol = this.#runtimeEntryURL.protocol;
    url.host = this.#runtimeEntryURL.host;
    if (forward.cf) {
      const cf = { ...fallbackCf, ...forward.cf };
      forward.headers.set(HEADER_CF_BLOB, JSON.stringify(cf));
    }
    if (forward.body !== null && forward.headers.get("Content-Length") === "0") {
      forward.headers.delete("Content-Length");
    }
    const forwardInit = forward;
    if (url.protocol === "https:") {
      forwardInit.dispatcher = allowUnauthorizedAgent;
    }
    const response = await fetch2(url, forwardInit);
    const stack = response.headers.get(CoreHeaders.ERROR_STACK);
    if (response.status === 500 && stack !== null) {
      const caught = JsonErrorSchema.parse(await response.json());
      throw reviveError(this.#workerSrcOpts, caught);
    }
    if (process.env.MINIFLARE_ASSERT_BODIES_CONSUMED !== void 0 && response.body !== null) {
      const originalLimit = Error.stackTraceLimit;
      Error.stackTraceLimit = Infinity;
      const error = new Error(
        "`body` returned from `Miniflare#dispatchFetch()` not consumed immediately"
      );
      Error.stackTraceLimit = originalLimit;
      setImmediate(() => {
        if (!response.bodyUsed)
          throw error;
      });
    }
    return response;
  };
  /** @internal */
  _getPluginStorage(plugin, namespace, persist) {
    const factory = this.#gatewayFactories[plugin];
    (0, import_assert21.default)(factory !== void 0);
    return factory.getStorage(namespace, persist);
  }
  /** @internal */
  async _getProxyClient() {
    this.#checkDisposed();
    await this.ready;
    (0, import_assert21.default)(this.#proxyClient !== void 0);
    return this.#proxyClient;
  }
  async getBindings(workerName) {
    const bindings = {};
    const proxyClient = await this._getProxyClient();
    let workerOpts;
    if (workerName === void 0) {
      workerOpts = this.#workerOpts[0];
    } else {
      workerOpts = this.#workerOpts.find(
        ({ core }) => (core.name ?? "") === workerName
      );
      if (workerOpts === void 0) {
        throw new TypeError(`${JSON.stringify(workerName)} worker not found`);
      }
    }
    workerName = workerOpts.core.name ?? "";
    for (const [key, plugin] of PLUGIN_ENTRIES) {
      const pluginBindings = await plugin.getNodeBindings(workerOpts[key]);
      for (const [name, binding] of Object.entries(pluginBindings)) {
        if (binding === kProxyNodeBinding) {
          const proxyBindingName = getProxyBindingName(key, workerName, name);
          const proxy = proxyClient.env[proxyBindingName];
          (0, import_assert21.default)(
            proxy !== void 0,
            `Expected ${proxyBindingName} to be bound`
          );
          bindings[name] = proxy;
        } else {
          bindings[name] = binding;
        }
      }
    }
    return bindings;
  }
  async #getProxy(pluginName, bindingName, workerName) {
    const proxyClient = await this._getProxyClient();
    const proxyBindingName = getProxyBindingName(
      pluginName,
      // Default to entrypoint worker if none specified
      workerName ?? this.#workerOpts[0].core.name ?? "",
      bindingName
    );
    const proxy = proxyClient.env[proxyBindingName];
    if (proxy === void 0) {
      const friendlyWorkerName = workerName === void 0 ? "entrypoint" : JSON.stringify(workerName);
      throw new TypeError(
        `${JSON.stringify(bindingName)} unbound in ${friendlyWorkerName} worker`
      );
    }
    return proxy;
  }
  // TODO(someday): would be nice to define these in plugins
  async getCaches() {
    const proxyClient = await this._getProxyClient();
    return proxyClient.global.caches;
  }
  getD1Database(bindingName, workerName) {
    return this.#getProxy(D1_PLUGIN_NAME, bindingName, workerName);
  }
  getDurableObjectNamespace(bindingName, workerName) {
    return this.#getProxy(DURABLE_OBJECTS_PLUGIN_NAME, bindingName, workerName);
  }
  getKVNamespace(bindingName, workerName) {
    return this.#getProxy(KV_PLUGIN_NAME, bindingName, workerName);
  }
  getQueueProducer(bindingName, workerName) {
    return this.#getProxy(QUEUES_PLUGIN_NAME, bindingName, workerName);
  }
  getR2Bucket(bindingName, workerName) {
    return this.#getProxy(R2_PLUGIN_NAME, bindingName, workerName);
  }
  async dispose() {
    this.#disposeController.abort();
    try {
      await this.ready;
    } finally {
      this.#removeTmpPathExitHook();
      this.#removeRuntimeExitHook?.();
      await this.#proxyClient?.dispose();
      await this.#runtime?.dispose();
      await this.#stopLoopbackServer();
      await import_fs6.default.promises.rm(this.#tmpPath, { force: true, recursive: true });
      maybeInstanceRegistry?.delete(this);
    }
  }
};
// Annotate the CommonJS export names for ESM import in node:
0 && (module.exports = {
  BASE64_REGEXP,
  BINDING_TEXT_NAMESPACE,
  BINDING_TEXT_PERSIST,
  BINDING_TEXT_PLUGIN,
  Base64DataSchema,
  CACHE_LOOPBACK_SCRIPT,
  CACHE_PLUGIN,
  CACHE_PLUGIN_NAME,
  CORE_PLUGIN,
  CORE_PLUGIN_NAME,
  CacheGateway,
  CacheOptionsSchema,
  CacheSharedOptionsSchema,
  CfHeader,
  CloseEvent,
  CloudflareFetchSchema,
  CoreBindings,
  CoreHeaders,
  CoreOptionsSchema,
  CoreSharedOptionsSchema,
  D1Error,
  D1Gateway,
  D1OptionsSchema,
  D1QuerySchema,
  D1SharedOptionsSchema,
  D1SingleQuerySchema,
  D1ValueSchema,
  D1_PLUGIN,
  D1_PLUGIN_NAME,
  DEFAULT_PERSIST_ROOT,
  DELETE,
  DURABLE_OBJECTS_PLUGIN,
  DURABLE_OBJECTS_PLUGIN_NAME,
  DURABLE_OBJECTS_STORAGE_SERVICE_NAME,
  DateSchema,
  DeferredPromise,
  DurableObjectsOptionsSchema,
  DurableObjectsSharedOptionsSchema,
  ErrorEvent,
  File,
  FileBlobStore,
  FormData,
  GET,
  GatewayFactory,
  GatewayMessageSchema,
  HEAD,
  HEADER_CF_BLOB,
  HEADER_PERSIST,
  HEX_REGEXP,
  Headers,
  HexDataSchema,
  HttpError,
  HttpOptions_Style,
  IgnoreSourcePredicateSchema,
  InternalR2Object,
  InternalR2ObjectBody,
  JsonSchema,
  KVError,
  KVGateway,
  KVOptionsSchema,
  KVSharedOptionsSchema,
  KV_PLUGIN,
  KV_PLUGIN_NAME,
  KeyValueStorage,
  LiteralSchema,
  Log,
  LogLevel,
  MemoryBlobStore,
  Message,
  MessageEvent,
  Miniflare,
  MiniflareCoreError,
  MiniflareError,
  ModuleDefinitionSchema,
  ModuleRuleSchema,
  ModuleRuleTypeSchema,
  MultipartUploadState,
  Mutex,
  NOOP_CACHE_SCRIPT,
  NoOpLog,
  PARAM_FILE_UNSANITISE,
  PATCH,
  PLUGINS,
  PLUGIN_ENTRIES,
  POST,
  PURGE,
  PUT,
  PersistenceSchema,
  ProxyAddresses,
  ProxyClient,
  ProxyOps,
  QUEUES_PLUGIN,
  QUEUES_PLUGIN_NAME,
  QueueConsumerOptionsSchema,
  QueueContentTypeSchema,
  QueuesError,
  QueuesGateway,
  QueuesHTTPError,
  QueuesOptionsSchema,
  R2AbortMultipartUploadRequestSchema,
  R2BindingRequestSchema,
  R2ChecksumsSchema,
  R2CompleteMultipartUploadRequestSchema,
  R2ConditionalSchema,
  R2CreateMultipartUploadRequestSchema,
  R2DeleteRequestSchema,
  R2EtagMatchSchema,
  R2EtagSchema,
  R2Gateway,
  R2GetRequestSchema,
  R2HeadRequestSchema,
  R2HttpFieldsSchema,
  R2ListRequestSchema,
  R2OptionsSchema,
  R2PublishedPartSchema,
  R2PutRequestSchema,
  R2RangeSchema,
  R2SharedOptionsSchema,
  R2UploadPartRequestSchema,
  R2_PLUGIN,
  R2_PLUGIN_NAME,
  RecordSchema,
  Request,
  Response,
  ResponseInfoSchema,
  Router,
  RouterError,
  Runtime,
  SERVICE_ENTRY,
  SERVICE_LOOPBACK,
  SOCKET_ENTRY,
  SQL_SCHEMA,
  SourceMapRegistry,
  SourceOptionsSchema,
  TlsOptions_Version,
  TypedEventTarget,
  WORKER_BINDING_SERVICE_LOOPBACK,
  WaitGroup,
  WebSocket,
  WebSocketPair,
  Worker_Binding_CryptoKey_Usage,
  _HttpParser,
  _QUEUES_COMPATIBLE_V8_VERSION,
  _RemoveTransformEncodingChunkedStream,
  _initialiseInstanceRegistry,
  _parseRanges,
  _testR2Conditional,
  _transformsForContentEncoding,
  allowUnauthorizedAgent,
  base64Decode,
  base64Encode,
  configureEntrySocket,
  coupleWebSocket,
  createArrayReadableStream,
  createFetchMock,
  createFileReadableStream,
  createFileStorage,
  createFileWritableStream,
  createHTTPReducers,
  createHTTPRevivers,
  createMemoryStorage,
  createMultipartArrayReadableStream,
  createMultipartFileReadableStream,
  createReadableStream,
  decodePersist,
  defaultClock,
  defaultTimers,
  deserialiseRegExps,
  encodePersist,
  escapeLike,
  fetch,
  formatResponse,
  getAccessibleHosts,
  getCacheServiceName,
  getGlobalServices,
  globsToRegExps,
  isFetcherFetch,
  isR2ObjectWriteHttpMetadata,
  isSitesRequest,
  kProxyNodeBinding,
  kVoid,
  lexicographicCompare,
  matchRoutes,
  maybeApply,
  maybeGetSitesManifestModule,
  maybeParseURL,
  millisToSeconds,
  namespaceEntries,
  namespaceKeys,
  nonCircularClone,
  normaliseDurableObject,
  parseRoutes,
  parseWithReadableStreams,
  pluginNamespacePersistWorker,
  prefixError,
  prefixStream,
  readPrefix,
  sanitisePath,
  secondsToMillis,
  serialiseRegExps,
  serializeConfig,
  stringifyWithStreams,
  structuredSerializableReducers,
  structuredSerializableRevivers,
  supportedCompatibilityDate,
  testRegExps,
  unwrapBYOBRequest,
  validateGetOptions,
  validateListOptions,
  viewToArray,
  viewToBuffer,
  zAwaitable
});
/*! Path sanitisation regexps adapted from node-sanitize-filename:
 * https://github.com/parshap/node-sanitize-filename/blob/209c39b914c8eb48ee27bcbde64b2c7822fdf3de/index.js#L4-L37
 *
 * Licensed under the ISC license:
 *
 * Copyright Parsha Pourkhomami <parshap@gmail.com>
 *
 * Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the
 * above copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY
 * DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
 * ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */
/*!
 * Copyright (c) 2011 Felix Geisendörfer (felix@debuggable.com)
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */
//# sourceMappingURL=index.js.map
