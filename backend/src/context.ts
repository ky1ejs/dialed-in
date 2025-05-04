import { Device, PrismaClient, User } from '@prisma/client';

export type UserContext = User & { device: Device }

export interface Context {
  prisma: PrismaClient;
  user: UserContext | null;
}
