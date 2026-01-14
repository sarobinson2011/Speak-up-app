import { MerkleTree } from 'merkletreejs';
import keccak256 from 'keccak256';

// Mock KYC database - in production this would be a real database
const verifiedUsers: string[] = [];

export function addVerifiedUser(userID: string) {
    if (!verifiedUsers.includes(userID)) {
        verifiedUsers.push(userID);
        console.log(`Added user ${userID} to merkle tree`);
    }
}

export function getMerkleTree(): MerkleTree {
    const leaves = verifiedUsers.map(id => keccak256(id));
    return new MerkleTree(leaves, keccak256, { sortPairs: true });
}

export function getMerkleRoot(): string {
    const tree = getMerkleTree();
    return tree.getHexRoot();
}

export function getMerkleProof(userID: string): string[] {
    const tree = getMerkleTree();
    const leaf = keccak256(userID);
    const proof = tree.getHexProof(leaf);
    return proof;
}

export function getVerifiedUsers(): string[] {
    return [...verifiedUsers];
}
