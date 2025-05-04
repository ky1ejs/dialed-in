import { MutationResolvers } from "src/__generated__/graphql";
import validateAuth from "src/auth/validateAuth";
import { dbToGraphQLDevice } from "src/resolvers/mappers/deviceMapper";

const validateAuthResolver: MutationResolvers["validateAuth"] = async (_, { authId, code, deviceName }, { prisma }) => {
  const user = await validateAuth(authId, code, prisma);

  if (typeof user !== "string") {
    // this is a login

    await prisma.emailAutheticationRequest.delete({
      where: {
        id: authId
      }
    })

    const device = await prisma.device.create({
      data: {
        name: deviceName,
        user: {
          connect: { id: user.id }
        }
      }
    })

    return {
      __typename: "AuthResponse",
      user: user,
      device: dbToGraphQLDevice(device)
    }
  }

  return {
    __typename: "EmptyResponse",
    success: true
  }
};

export default validateAuthResolver;