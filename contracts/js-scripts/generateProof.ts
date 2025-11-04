import { Noir } from "@noir-lang/noir_js";
import { ethers } from "ethers";
import { UltraHonkBackend } from "@aztec/bb.js";
import { fileURLToPath } from "url";
import path from "path";
import fs from "fs";
import { error } from "console";


//get the circuit file

//path.dirname(fileURLToPath(import.meta.url));      //refers to file://Users/khushipanwar/projects/zk-panagram/contracts/js-scripts/generateProof.ts
//"../../circuits/target/zk_panagram.json";

const circuitPath = path.resolve(
    path.dirname(fileURLToPath(import.meta.url)), "../../circuits/target/zk_panagram.json"
);

const circuit = JSON.parse(fs.readFileSync(circuitPath, "utf8"));


export default async function generateProof(input: any) {
    return null;
}

(async () => {
    try {
        // Get the input values and generate proof
        const inputsArray = process.argv.slice(2);
        const noir = new Noir(circuit);
        const bb = new UltraHonkBackend(circuit.bytecode, { threads: 1 });
        const inputs = {
            guess_hash: inputsArray[0],
            answer_hash: inputsArray[1]
        }
        const { witness } = await noir.execute(inputs);

        const originalLog = console.log;
        console.log = () => { }

        const { proof } = await bb.generateProof(witness, { keccak: true });
        console.log = originalLog;

        // Check proof properties
        console.error("Proof type:", typeof proof);
        console.error("Proof is Buffer:", Buffer.isBuffer(proof));
        console.error("Proof length:", proof.length);
        console.error("Proof keys:", Object.keys(proof));
        
        // Try to serialize the proof properly for the verifier
        // The proof might need to be serialized to match the expected format
        const proofBytes = Buffer.isBuffer(proof) ? proof : Buffer.from(proof);
        console.error("Final proof bytes length:", proofBytes.length);
        
        // Output as hex string for vm.ffi
        const proofHex = "0x" + proofBytes.toString("hex");
        process.stdout.write(proofHex);
        process.exit(0);
    } catch (error) {
        console.error("Error:", error);
        process.exit(1);
    }
})();