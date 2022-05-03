import { prisma } from "lib/prisma";
import { findFirstSmallestInArray } from "utils/findFirstSmallestInArray";

interface Options {
  type: "leo" | "ems-fd" | "combined";
}

export async function findNextAvailableIncremental(options: Options) {
  const prismaNames = {
    leo: "officer",
    "ems-fd": "emsFdDeputy",
    combined: "combinedLeoUnit",
  };
  const t = prismaNames[options.type];

  // @ts-expect-error properties for this function are the same.
  const units = (await prisma[t].findMany({
    where: { incremental: { not: null } },
  })) as { incremental: number }[];

  const incrementalNumbers = units.map((v) => v.incremental);
  return findFirstSmallestInArray(incrementalNumbers);
}
