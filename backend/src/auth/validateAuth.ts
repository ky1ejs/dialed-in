import { PrismaClient, User } from "@prisma/client"

export async function validateAuth(id: string, code: string, prisma: PrismaClient): Promise<User | string> {
  const request = await prisma.emailAutheticationRequest.findUnique({ where: { id } })

  if (!request) {
    throw new Error("Invalid request")
  }

  if (request.code !== code) {
    throw new Error("Invalid code")
  }

  const account = await prisma.user.findUnique({
    where: {
      email: request.email
    }
  })

  return account ?? request.email
}

export default validateAuth;
