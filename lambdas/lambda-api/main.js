const seleccionadoraName = process.env.SELECCIONADORA_NAME;

/**
 * Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */
const {
  InvokeCommand,
  LambdaClient,
  LogType,
} = require("@aws-sdk/client-lambda");

/** snippet-start:[javascript.v3.lambda.actions.Invoke] */
const invoke = async (funcName, payload) => {
  const client = new LambdaClient();
  const command = new InvokeCommand({
    FunctionName: funcName,
    Payload: JSON.stringify(payload),
    LogType: LogType.Tail,
  });

  const { Payload, LogResult } = await client.send(command);
  const result = Buffer.from(Payload).toString();
  const logs = Buffer.from(LogResult, "base64").toString();
  return { logs, result };
};
/** snippet-end:[javascript.v3.lambda.actions.Invoke] */

module.exports.handler = async (event, context) => {
  const funcName = seleccionadoraName;
  const payload = { key1: "value1", key2: "value2", key3: "value3" };
  const { logs, result } = await invoke(funcName, payload);
  const response = JSON.parse(result);
  return {
    statusCode: 200,
    body: JSON.stringify(response),
  };
};
