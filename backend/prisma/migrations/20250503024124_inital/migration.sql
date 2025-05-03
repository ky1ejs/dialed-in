-- CreateEnum
CREATE TYPE "BurrType" AS ENUM ('CONICAL', 'FLAT');

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Grinder" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "brand" TEXT NOT NULL,
    "supportedBurrTypes" "BurrType"[],

    CONSTRAINT "Grinder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Roaster" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "location" TEXT NOT NULL,

    CONSTRAINT "Roaster_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Coffee" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "brand" TEXT NOT NULL,
    "roast" TEXT NOT NULL,
    "roastDate" TIMESTAMP(3) NOT NULL,
    "notes" TEXT[],
    "roasterId" TEXT NOT NULL,

    CONSTRAINT "Coffee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Brew" (
    "id" TEXT NOT NULL,
    "coffeeId" TEXT NOT NULL,
    "doseGrams" DOUBLE PRECISION NOT NULL,
    "brewTime" INTEGER NOT NULL,
    "waterTemp" DOUBLE PRECISION NOT NULL,
    "yieldGrams" DOUBLE PRECISION NOT NULL,
    "grinderId" TEXT NOT NULL,
    "grindSize" INTEGER NOT NULL,
    "grindRpm" INTEGER NOT NULL,
    "machineId" TEXT NOT NULL,
    "brewNotes" TEXT NOT NULL,
    "brewDate" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Brew_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Machine" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "brand" TEXT NOT NULL,
    "type" TEXT NOT NULL,

    CONSTRAINT "Machine_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- AddForeignKey
ALTER TABLE "Coffee" ADD CONSTRAINT "Coffee_roasterId_fkey" FOREIGN KEY ("roasterId") REFERENCES "Roaster"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Brew" ADD CONSTRAINT "Brew_coffeeId_fkey" FOREIGN KEY ("coffeeId") REFERENCES "Coffee"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Brew" ADD CONSTRAINT "Brew_grinderId_fkey" FOREIGN KEY ("grinderId") REFERENCES "Grinder"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Brew" ADD CONSTRAINT "Brew_machineId_fkey" FOREIGN KEY ("machineId") REFERENCES "Machine"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
