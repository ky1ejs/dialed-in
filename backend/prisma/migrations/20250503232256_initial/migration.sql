-- CreateExtension
CREATE EXTENSION IF NOT EXISTS "citext";

-- CreateEnum
CREATE TYPE "BurrType" AS ENUM ('CONICAL', 'FLAT');

-- CreateEnum
CREATE TYPE "TokenEnv" AS ENUM ('STAGING', 'PRODUCTION');

-- CreateEnum
CREATE TYPE "PushPlatform" AS ENUM ('IOS', 'ANDROID', 'WEB');

-- CreateTable
CREATE TABLE "User" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "email" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "bio" TEXT,
    "hashedEmail" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EmailAutheticationRequest" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "email" CITEXT NOT NULL,
    "code" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "EmailAutheticationRequest_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Grinder" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "brand" TEXT NOT NULL,
    "supportedBurrTypes" "BurrType"[],

    CONSTRAINT "Grinder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Roaster" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,

    CONSTRAINT "Roaster_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Coffee" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "brand" TEXT NOT NULL,
    "roast" TEXT NOT NULL,
    "roastDate" TIMESTAMP(3) NOT NULL,
    "notes" TEXT[],
    "roasterId" UUID NOT NULL,

    CONSTRAINT "Coffee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Brew" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "coffeeId" UUID NOT NULL,
    "doseGrams" DOUBLE PRECISION NOT NULL,
    "brewTime" INTEGER NOT NULL,
    "waterTemp" DOUBLE PRECISION NOT NULL,
    "yieldGrams" DOUBLE PRECISION NOT NULL,
    "grinderId" UUID NOT NULL,
    "grindSize" INTEGER NOT NULL,
    "grindRpm" INTEGER NOT NULL,
    "machineId" UUID NOT NULL,
    "brewNotes" TEXT NOT NULL,
    "brewDate" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Brew_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Machine" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "brand" TEXT NOT NULL,
    "type" TEXT NOT NULL,

    CONSTRAINT "Machine_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Device" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "sessionId" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" UUID NOT NULL,

    CONSTRAINT "Device_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PushToken" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "token" TEXT NOT NULL,
    "env" "TokenEnv" NOT NULL,
    "platform" "PushPlatform" NOT NULL,
    "device_id" UUID NOT NULL,

    CONSTRAINT "PushToken_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE UNIQUE INDEX "EmailAutheticationRequest_email_key" ON "EmailAutheticationRequest"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Device_sessionId_key" ON "Device"("sessionId");

-- CreateIndex
CREATE UNIQUE INDEX "PushToken_device_id_key" ON "PushToken"("device_id");

-- AddForeignKey
ALTER TABLE "Coffee" ADD CONSTRAINT "Coffee_roasterId_fkey" FOREIGN KEY ("roasterId") REFERENCES "Roaster"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Brew" ADD CONSTRAINT "Brew_coffeeId_fkey" FOREIGN KEY ("coffeeId") REFERENCES "Coffee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Brew" ADD CONSTRAINT "Brew_grinderId_fkey" FOREIGN KEY ("grinderId") REFERENCES "Grinder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Brew" ADD CONSTRAINT "Brew_machineId_fkey" FOREIGN KEY ("machineId") REFERENCES "Machine"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Device" ADD CONSTRAINT "Device_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PushToken" ADD CONSTRAINT "PushToken_device_id_fkey" FOREIGN KEY ("device_id") REFERENCES "Device"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- Create function to automatically update updatedAt timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updatedAt = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for tables with updatedAt
CREATE TRIGGER update_user_updated_at
    BEFORE UPDATE ON "User"
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_device_updated_at 
    BEFORE UPDATE ON "Device"
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();