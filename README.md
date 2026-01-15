# Speak Up - Anonymous Petition Platform

A decentralized petition platform with AI-powered content moderation and anonymous credential system.

**Live Demo:**
- Frontend: http://localhost:5173
- Backend: http://localhost:3001
- Smart Contracts: Aurora Testnet

**Deployed Contracts:**
- VotingCredential: `0x8A086320D7320a7243c02A24D4ceA199EC45D65E`
- PetitionRegistry: `0x8D1908223856e3C38f46263dBAb6f0e38c5fab0f`
- Explorer: https://explorer.testnet.aurora.dev

---

## 🎯 What This Does

**Core Features:**
- Create and sign petitions anonymously
- AI-powered comment moderation (GPT-4)
- Immutable on-chain record of all petitions/signatures
- Credential-based access control (ZK-ready architecture)

**Why It Matters:**
People can voice opinions on sensitive topics without fear of retaliation. All data is cryptographically secured on-chain, with AI preventing abuse.

---

## 🏗️ Architecture
```
┌─────────────┐
│   Frontend  │  React + Vite + ethers.js
│  (Port 5173)│  User creates petitions, signs, comments
└──────┬──────┘
       │
       ├─────────────────┐
       │                 │
       ▼                 ▼
┌─────────────┐   ┌─────────────┐
│   Backend   │   │   Aurora    │
│  (Port 3001)│   │  Testnet    │
│             │   │             │
│ - AI Mod    │   │ - Petitions │
│ - Merkle    │   │ - Signatures│
│ - API       │   │ - Comments  │
└─────────────┘   └─────────────┘
       │
       ▼
┌─────────────┐
│   OpenAI    │
│   GPT-4     │
│  Moderator  │
└─────────────┘
```

---

## 📁 Project Structure
```
Speak-up-app/
├── contracts/              # Foundry smart contracts
│   ├── src/
│   │   ├── VotingCredential.sol
│   │   └── PetitionRegistry.sol
│   ├── script/Deploy.s.sol
│   └── test/
├── frontend/               # React + Vite
│   └── src/
│       ├── App.tsx
│       ├── contracts.ts
│       └── abis.ts
├── backend/                # Node.js API
│   └── src/
│       ├── index.ts
│       ├── moderation.ts
│       └── merkle.ts
├── zk-circuits/           # Circom circuits (Phase 2)
│   └── circuits/
└── README.md
```

---

## 🚀 Quick Start

### Prerequisites
```bash
# Install dependencies
node --version  # v18+
foundry --version
```

### 1. Smart Contracts
```bash
cd contracts

# Deploy to Aurora testnet
forge script script/Deploy.s.sol:DeployScript \
  --rpc-url https://testnet.aurora.dev \
  --account dev-deployer \
  --sender 0xF8f8269488f73fab3935555FCDdD6035699deE25 \
  --broadcast \
  --legacy \
  --verify \
  --verifier blockscout \
  --verifier-url https://explorer.testnet.aurora.dev/api/v1

# Grant yourself a credential
cast send 0x8A086320D7320a7243c02A24D4ceA199EC45D65E \
  "grantCredential(address)" \
  0xF8f8269488f73fab3935555FCDdD6035699deE25 \
  --rpc-url https://testnet.aurora.dev \
  --account dev-deployer \
  --legacy
```

### 2. Backend
```bash
cd backend

# Install dependencies
npm install

# Create .env file
cat > .env << EOF
PORT=3001
OPENAI_API_KEY=your_openai_key_here
AURORA_TESTNET_RPC=https://testnet.aurora.dev
MODERATOR_PRIVATE_KEY=your_private_key_here
PETITION_REGISTRY_ADDRESS=0x8D1908223856e3C38f46263dBAb6f0e38c5fab0f
EOF

# Start server
npm run dev
```

### 3. Frontend
```bash
cd frontend

# Install dependencies
npm install

# Start dev server
npm run dev

# Open http://localhost:5173
```

---

## 🎮 Using the App

### Create a Petition

1. Connect MetaMask to Aurora Testnet
2. Click "Create Petition"
3. Fill in title, description, duration
4. Submit (requires VotingCredential)

### Sign a Petition

1. Browse petitions
2. Click "Sign Petition"
3. Approve transaction
4. Can only sign once per petition

### Add Comments

1. Open petition
2. Click "View Comments"
3. Write comment
4. Submit → AI automatically reviews
5. Approved comments appear instantly
6. Rejected comments don't show

---

## 🤖 AI Moderation

**How It Works:**
```
User submits comment
    ↓
Backend receives via API
    ↓
GPT-4o-mini reviews for:
  - Hate speech
  - Violence
  - Illegal content
    ↓
Decision (0-1 confidence):
  ├─ >0.7 confident safe → Auto-approve
  ├─ <0.7 confidence → Flag for review
  └─ >0.7 confident unsafe → Reject
    ↓
Backend calls approveComment() on-chain
    ↓
Comment visible to all users
```

**Moderation Rules:**
- ✅ Allows: Strong political speech, criticism, profanity
- ❌ Rejects: Hate speech, violence, illegal content

**Cost:** ~$0.0001 per comment (GPT-4o-mini)

---

## 🔐 Smart Contracts

### VotingCredential.sol

Simple credential system (Phase 1).
```solidity
// Grant credential (admin only)
function grantCredential(address user) external onlyOwner

// Check if user has credential
function hasCredential(address user) view returns (bool)
```

**Phase 2:** Will be replaced with ZK proof verification.

### PetitionRegistry.sol

Main petition logic.
```solidity
// Create new petition
function createPetition(
    string title, 
    string description, 
    uint256 durationDays
) returns (uint256 petitionId)

// Sign petition (once per credential)
function signPetition(uint256 petitionId)

// Submit comment (AI reviews before approval)
function submitComment(uint256 petitionId, string content)

// Approve comment (backend only)
function approveComment(
    uint256 petitionId, 
    uint256 commentIndex
)
```

---

## 🌐 API Endpoints

### Backend (http://localhost:3001)

**Health Check:**
```bash
GET /health
```

**AI Moderation:**
```bash
POST /api/moderate-comment
Body: {
  petitionId: number,
  commentIndex: number,
  content: string
}
```

**Credentials (Phase 2):**
```bash
# Add approved credential hash
POST /api/admin/add-credential
Body: { secret: string }

# Get all approved hashes
GET /api/approved-hashes

# Check if credential is valid
POST /api/check-credential
Body: { secret: string }
```

---

## 🔍 Debugging & Testing

### View On-Chain Data
```bash
# Read petition details
cast call 0x8D1908223856e3C38f46263dBAb6f0e38c5fab0f \
  "petitions(uint256)" \
  0 \
  --rpc-url https://testnet.aurora.dev

# Check if address has credential
cast call 0x8A086320D7320a7243c02A24D4ceA199EC45D65E \
  "hasCredential(address)(bool)" \
  0xYOUR_ADDRESS \
  --rpc-url https://testnet.aurora.dev

# Read comment (including hidden ones)
cast call 0x8D1908223856e3C38f46263dBAb6f0e38c5fab0f \
  "petitionComments(uint256,uint256)(address,string,bool,uint256)" \
  PETITION_ID COMMENT_INDEX \
  --rpc-url https://testnet.aurora.dev
```

### Test AI Moderation
```bash
# Approve comment manually
cast send 0x8D1908223856e3C38f46263dBAb6f0e38c5fab0f \
  "approveComment(uint256,uint256)" \
  PETITION_ID COMMENT_INDEX \
  --rpc-url https://testnet.aurora.dev \
  --account dev-deployer \
  --legacy
```

---

## 🧪 Test Wallets

**Admin Wallet (Owner):**
- Address: `0xF8f8269488f73fab3935555FCDdD6035699deE25`
- Has VotingCredential ✓
- Can grant credentials

**Test Wallet 2:**
- Address: `0xC26741bac14a3Ba52517D6fD825eF4513454178E`
- Has VotingCredential ✓
- For testing multi-user scenarios

---

## 📊 Key Features Implemented

### ✅ Phase 1 (Current)

- [x] Petition creation and signing
- [x] Comment system with approval workflow
- [x] AI-powered content moderation
- [x] Credential-based access control
- [x] On-chain immutable records
- [x] Real-time wallet switching
- [x] Deployed & verified contracts
- [x] Backend API with OpenAI integration
- [x] React frontend with MetaMask

### 🚧 Phase 2 (Roadmap)

- [ ] ZK credential system (Noir)
- [ ] KYC provider integration
- [ ] Client-side proof generation
- [ ] Merkle tree membership proofs
- [ ] Anonymous credentials (no on-chain identity link)
- [ ] Upgradeable contracts (proxy pattern)
- [ ] NEAR wallet integration
- [ ] Community appeals for moderation
- [ ] Admin dashboard for flagged content

---

## 🔒 Security Considerations

### Current Model

**On-Chain:**
- All petitions/signatures are public
- Comments are public (if approved)
- Wallet addresses are visible
- Immutable (can't delete)

**Off-Chain (AI Moderation):**
- Backend has moderator private key
- OpenAI sees comment content
- Backend can approve/reject

### Phase 2 (ZK Credentials)

**On-Chain:**
- Proof of credential (but not which one)
- Nullifier prevents double-use
- No link between real identity and wallet

**Off-Chain:**
- KYC provider knows real identity
- Backend knows verified user IDs
- ZK proof generated client-side (secrets never leave browser)

### Threat Model

**Protected Against:**
- ✅ Sybil attacks (one credential = one vote)
- ✅ Double-signing (contract prevents)
- ✅ Hate speech/abuse (AI moderation)
- ✅ Data tampering (blockchain immutability)

**NOT Protected Against (Yet):**
- ❌ On-chain identity tracking (Phase 2 fixes this)
- ❌ Backend censorship (decentralize in Phase 2)
- ❌ Wallet address deanonymization

---

## 💰 Cost Analysis

### Gas Costs (Aurora Testnet)
```
Create Petition:    ~100,000 gas  (~$0.01)
Sign Petition:      ~50,000 gas   (~$0.005)
Submit Comment:     ~80,000 gas   (~$0.008)
Approve Comment:    ~50,000 gas   (~$0.005)
```

### Backend Costs
```
AI Moderation:      $0.0001/comment (GPT-4o-mini)
Server:             $5-20/month (DigitalOcean/Heroku)
```

**Sustainability:**
- Small petition creation fee (0.05-0.1 NEAR)
- Free to sign/comment
- Self-sustaining at 100+ petitions/month

---

## 🐛 Known Issues & Workarounds

### Issue: MetaMask Network Switching

**Problem:** MetaMask doesn't auto-switch to Aurora Testnet

**Workaround:**
1. Manually add Aurora Testnet to MetaMask
2. Network Name: Aurora Testnet
3. RPC URL: https://testnet.aurora.dev
4. Chain ID: 1313161555
5. Currency: ETH

### Issue: Comments Not Showing

**Problem:** Comment submitted but not visible

**Cause:** AI moderation rejected it or still pending

**Check:**
```bash
# View all comments including unapproved
cast call CONTRACT_ADDRESS \
  "petitionComments(uint256,uint256)" \
  PETITION_ID COMMENT_INDEX \
  --rpc-url https://testnet.aurora.dev
```

### Issue: "No Credential" Error

**Problem:** Can't create petition/sign

**Fix:**
```bash
# Grant credential to your address
cast send 0x8A086320D7320a7243c02A24D4ceA199EC45D65E \
  "grantCredential(address)" \
  YOUR_ADDRESS \
  --rpc-url https://testnet.aurora.dev \
  --account dev-deployer \
  --legacy
```

---

## 📚 Technical Deep Dive

### Why Aurora?

- ✅ EVM-compatible (Solidity works)
- ✅ Low gas fees (~$0.01 per transaction)
- ✅ Fast finality (~2 seconds)
- ✅ NEAR ecosystem (future NEAR wallet integration)
- ✅ Good block explorer (Blockscout)

### Why Vite over Next.js?

- ✅ Faster dev server
- ✅ Simpler config
- ✅ Lighter bundle
- ✅ Better for SPAs

### Why GPT-4o-mini?

- ✅ Cheapest GPT-4 variant ($0.15/1M tokens)
- ✅ Fast responses (<1 second)
- ✅ Good enough for moderation
- ✅ JSON mode support

### Why Poseidon Hashing?

- ✅ ZK-friendly (optimized for circuits)
- ✅ Efficient in Circom/Noir
- ✅ Widely used in ZK applications
- ✅ Deterministic (same input = same output)

---

## 🛣️ Roadmap

### Month 1-2 (Completed ✓)
- Core petition system
- AI moderation
- Smart contracts deployed
- Working POC

### Month 3-4 (Phase 2)
- Noir ZK circuits
- KYC integration
- Anonymous credentials
- Client-side proof generation

### Month 5-6 (Scale)
- Upgradeable contracts
- Multi-chain support
- Mobile app
- Community governance

### Month 7+ (Production)
- Mainnet deployment
- Marketing/outreach
- Partnerships with advocacy groups
- Grant funding

---

## 🤝 Contributing

This is a personal project, but ideas/feedback welcome!

**Areas for contribution:**
- Frontend UX improvements
- Additional moderation rules
- ZK circuit optimization
- Mobile responsive design
- Translations

---

## 📖 Learning Resources

### ZK Proofs
- [ZK-SNARKs Explained](https://z.cash/technology/zksnarks/)
- [Circom Documentation](https://docs.circom.io)
- [Noir Language](https://noir-lang.org)

### Smart Contracts
- [Foundry Book](https://book.getfoundry.sh)
- [Solidity Docs](https://docs.soliditylang.org)
- [Aurora Docs](https://doc.aurora.dev)

### AI Moderation
- [OpenAI API](https://platform.openai.com/docs)
- [Content Moderation Best Practices](https://openai.com/blog/new-and-improved-content-moderation-tooling)

---

## ⚖️ License

MIT License - build whatever you want with this!

---

## 🙏 Acknowledgments

**Built with:**
- Foundry (smart contract development)
- React + Vite (frontend)
- Node.js + Express (backend)
- OpenAI GPT-4 (AI moderation)
- Circom (ZK circuits)
- Aurora/NEAR (blockchain)

**Inspired by:**
- Zcash (privacy)
- Semaphore (anonymous signaling)
- Snapshot (off-chain voting)
- Tornado Cash (mixing)

---

## 📧 Contact

**Developer:** Steve
**Project:** Speak Up - Anonymous Petitions
**Status:** POC Complete, Phase 2 in Progress

---

**Last Updated:** January 2026
**Version:** 1.0.0 (Phase 1 Complete)