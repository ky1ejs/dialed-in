import { Device } from "@prisma/client";
import { Device as GraphQLDevice } from "src/__generated__/graphql";

export function dbToGraphQLDevice(device: Device): GraphQLDevice {
  return {
    name: device.name,
    sessionId: device.sessionId
  }
} 
