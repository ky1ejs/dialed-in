import { PrismaClient } from "@prisma/client"
import { GraphQLError } from "graphql"
import validateAuth from "./validateAuth"
import sha256 from "../services/sha256"

type CompleteAccountParams = {
  name: string
  username: string
  bio: string | null
  deviceName: string
}

export default async function completeAccount(authId: string, code: string, params: CompleteAccountParams, prisma: PrismaClient) {
  const accountOrEmail = await validateAuth(authId, code, prisma)

  if (typeof accountOrEmail !== "string") {
    throw new GraphQLError("User is already complete")
  }

  const userExists = await prisma.user.findFirst({
    where: {
      OR: [
        { email: accountOrEmail },
        { username: params.username }
      ]
    }
  })

  if (userExists) {
    throw new GraphQLError("Username taken")
  }

  await prisma.emailAutheticationRequest.delete({
    where: {
      id: authId
    }
  })

  const user =
    await prisma.user.create({
      include: {
        devices: true,
      },
      data: {
        username: params.username,
        email: accountOrEmail,
        hashedEmail: sha256(accountOrEmail),
        name: params.name,
        bio: params.bio,
      }
    })

  const newDevice = await prisma.device.create({
    data: {
      name: params.deviceName,
      user: {
        connect: {
          id: user.id
        }
      }
    }
  })

  return {
    user,
    device: newDevice
  }
}
