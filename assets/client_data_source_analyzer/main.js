
import "core-js";
import { pipeline, env } from "@xenova/transformers";

async function callAiModel(  
  type,
  model,
  additionalPipelineParams,
  data,
  additionalModelParams,
  remoteHostSettings) {
    if (!type) {
      return JSON.stringify({ error: "There is no type" });
    }
    if (!model) {
      return JSON.stringify({ error: "There is no model" });
    }
    if (!data) {
      return JSON.stringify({ error: "There is no data" });
    }
    if (!remoteHostSettings) {
      return JSON.stringify({ error: "There is no remoteHostSettings" });
    }
    env.allowLocalModels = false;
    env.allowRemoteModels = true;
    env.remoteHost = remoteHostSettings["remoteHost"];
    env.remotePathTemplate = remoteHostSettings["remotePathTemplate"];
    try {
      let aiModel = await pipeline(type, model, additionalPipelineParams ?? {});
      let output = await aiModel(data, additionalModelParams ?? {});
      return JSON.stringify({ output:  output});
    } catch (error) {
      let errorMessage = error.message;
      if (error.message.includes("memory access out of bounds")) {
        errorMessage = "Model error. Memory access out of bounds" 
      }
      return JSON.stringify({ error: errorMessage }); 
    }
}

async function loadModelToCache(
  type,
  model,
  additionalPipelineParams,
  remoteHostSettings) {
    if (!type) {
      return JSON.stringify({ error: "There is no type" });
    }
    if (!model) {
      return JSON.stringify({ error: "There is no model" });
    }
    if (!remoteHostSettings) {
      return JSON.stringify({ error: "There is no remoteHostSettings" });
    }
  env.allowLocalModels = false;
  env.allowRemoteModels = true;
  env.remoteHost = remoteHostSettings["remoteHost"];
  env.remotePathTemplate = remoteHostSettings["remotePathTemplate"];
  try {
    await pipeline(type, model, additionalPipelineParams ?? {});
    return JSON.stringify({
      success: true,
    });
  } catch (error) {
    return JSON.stringify({ 
      success: false,
      error: error.message});
  }
}


window.callAiModel = callAiModel;
window.loadModelToCache = loadModelToCache;

///unimplemented

// window.callAIModelUsingLocalRepository = callAIModelUsingLocalRepository;

// async function callAIModelUsingLocalRepository (
//   type,
//   model,
//   localModelPath,
//   additionalPipelineParams,
//   data,
//   additionalModelParams
// )  {
//   if (!type) {
//     return JSON.stringify({ error: "There is no type" });
//   }
//   if (!model) {
//     return JSON.stringify({ error: "There is no model" });
//   }
//   if (!data) {
//     return JSON.stringify({ error: "There is no data" });
//   }
//   if (!localModelPath) {
//     return JSON.stringify ({ error: "There is no localModelPath"});
//   }
//   env.allowLocalModels = true;
//   env.allowRemoteModels = false;
//   // env.localModelPath = 'assets/packages/data_source_analyzer/assets/client_data_source_analyzer/dist/';
//   // env.localModelPath = "./models";
//   env.localModelPath = localModelPath;
//   // env.localModelPath = "/assets/packages/data_source_analyzer/assets/client_data_source_analyzer/dist/";
  // env.backends.onnx.wasm.wasmPaths = './';
  // const DEFAULT_LOCAL_MODEL_PATH = "/models/";
  // env.localModelPath = './assets/packages/data_source_analyzer/assets/client_data_source_analyzer/dist/models/';
  // env.localModelPath = DEFAULT_LOCAL_MODEL_PATH;
  // env.localModelPath = "./models";
  // env.localModelPath = "../assets/models/";
//   additionalPipelineParams = {...additionalPipelineParams, ...{local_files_only : true}};
//   try {
//     let aiModel = await pipeline(type, model, additionalPipelineParams ?? {});
//     let output = await aiModel(data, additionalModelParams ?? {});
//     return JSON.stringify({ output:  output});
//   } catch (error) {
//     let errorMessage = error.message;
//     if (error.message.includes("memory access out of bounds")) {
//       errorMessage = "Model error. Memory access out of bounds" 
//     }
//     return JSON.stringify({ error: errorMessage }); 
//   }

// };
