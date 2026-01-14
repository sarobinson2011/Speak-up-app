# SpeakUp - system design

## The Layout
```
speak-up-app/
├── contracts/              # Foundry smart contracts
│   ├── src/
│   │   ├── VotingCredential.sol
│   │   └── PetitionRegistry.sol
│   ├── script/
│   │   └── Deploy.s.sol
│   ├── test/
│   │   └── PetitionRegistry.t.sol
│   └── foundry.toml
│
├── frontend/               # Vite app
│   ├── src/
│   │   ├── components/
│   │   │   ├── PetitionCard.tsx
│   │   │   ├── CreatePetition.tsx
│   │   │   └── WalletConnect.tsx
│   │   ├── pages/
│   │   │   ├── index.tsx
│   │   │   └── petition/[id].tsx
│   │   └── lib/
│   │       └── contracts.ts
│   ├── public/
│   └── package.json
│
├── backend/                # Node.js API (AI moderation) 
│   ├── src/
│   │   ├── index.ts
│   │   ├── moderation.ts
│   │   └── db.ts
│   ├── scripts/
│   └── package.json
│
├── docs/
│   ├── ARCHITECTURE.md
│   └── DEPLOYMENT.md
│
├── .gitignore
└── README.md
```

## Smart contract addresses - Aurora Testnet (verified)

VotingCredential:
0x8A086320D7320a7243c02A24D4ceA199EC45D65E

PetitionRegistry: 
0x8D1908223856e3C38f46263dBAb6f0e38c5fab0f



