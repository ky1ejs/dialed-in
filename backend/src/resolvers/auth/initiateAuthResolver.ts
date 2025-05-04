import { MutationResolvers } from "src/__generated__/graphql";
import initiateAuthentication from "src/auth/initiateAuth";

const initiateAuthResolver: MutationResolvers['initiateAuth'] = async (_, { email }, { prisma }) => {
  return await initiateAuthentication(email, prisma)
}

export default initiateAuthResolver;
