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
├── frontend/               # Next.js app
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

## ...


