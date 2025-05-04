import { MutationResolvers } from "src/__generated__/graphql";
import completeAccount from "src/auth/completeAccount";
import { dbToGraphQLDevice } from "src/resolvers/mappers/deviceMapper";
import { dbToGraphQLUser } from "src/resolvers/mappers/userMapper";

const completeAccountResolver: MutationResolvers["completeAccount"] = async (_, { input }, { prisma }) => {
  const result = await completeAccount(input.authId, input.code, {
    name: input.name,
    username: input.username,
    bio: input.bio ?? null,
    deviceName: input.deviceName
  }, prisma)

  return {
    device: dbToGraphQLDevice(result.device),
    user: dbToGraphQLUser(result.user)
  }
}

export default completeAccountResolver;
