import { GraphQLError } from "graphql";
import { QueryResolvers } from "src/__generated__/graphql";

const isUsernameAvailableResolve: QueryResolvers["isUsernameAvailable"] = async (_, { username }, { prisma }) => {
  try {
    const user = await prisma.user.findUnique({
      where: { username },
    });
    return !user;
  } catch (error) {
    throw error;
  }
};

export default isUsernameAvailableResolve;
