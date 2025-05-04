import { User } from "@prisma/client"
import { User as GraphQLUser } from "src/__generated__/graphql"

export function dbToGraphQLUser(user: User): GraphQLUser {
  return {
    email: user.email,
    username: user.username,
    name: user.name,
    bio: user.bio,
  }
}
