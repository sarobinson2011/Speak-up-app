// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./VotingCredential.sol";

contract PetitionRegistry {
    VotingCredential public credentialContract;
    
    struct Petition {
        address creator;
        string title;
        string description;
        uint256 deadline;
        uint256 signatureCount;
        bool active;
    }
    
    struct Comment {
        address author;
        string content;
        bool approved;
        uint256 timestamp;
    }
    
    mapping(uint256 => Petition) public petitions;
    mapping(uint256 => mapping(address => bool)) public hasSigned;
    mapping(uint256 => Comment[]) public petitionComments;
    
    uint256 public petitionCount;
    address public moderator;
    
    event PetitionCreated(uint256 indexed petitionId, address indexed creator, string title);
    event PetitionSigned(uint256 indexed petitionId, address indexed signer);
    event CommentSubmitted(uint256 indexed petitionId, address indexed author, uint256 commentIndex);
    event CommentApproved(uint256 indexed petitionId, uint256 commentIndex);
    
    modifier onlyModerator() {
        require(msg.sender == moderator, "Not moderator");
        _;
    }
    
    modifier hasCredential() {
        require(credentialContract.hasCredential(msg.sender), "No credential");
        _;
    }
    
    constructor(address _credentialContract) {
        credentialContract = VotingCredential(_credentialContract);
        moderator = msg.sender;
    }
    
    function createPetition(
        string memory title,
        string memory description,
        uint256 durationDays
    ) external hasCredential returns (uint256) {
        uint256 petitionId = petitionCount++;
        
        petitions[petitionId] = Petition({
            creator: msg.sender,
            title: title,
            description: description,
            deadline: block.timestamp + (durationDays * 1 days),
            signatureCount: 0,
            active: true
        });
        
        emit PetitionCreated(petitionId, msg.sender, title);
        return petitionId;
    }
    
    function signPetition(uint256 petitionId) external hasCredential {
        require(petitions[petitionId].active, "Petition not active");
        require(block.timestamp < petitions[petitionId].deadline, "Petition expired");
        require(!hasSigned[petitionId][msg.sender], "Already signed");
        
        hasSigned[petitionId][msg.sender] = true;
        petitions[petitionId].signatureCount++;
        
        emit PetitionSigned(petitionId, msg.sender);
    }
    
    function submitComment(
        uint256 petitionId,
        string memory content
    ) external hasCredential {
        require(petitions[petitionId].active, "Petition not active");
        
        Comment memory newComment = Comment({
            author: msg.sender,
            content: content,
            approved: false,
            timestamp: block.timestamp
        });
        
        petitionComments[petitionId].push(newComment);
        uint256 commentIndex = petitionComments[petitionId].length - 1;
        
        emit CommentSubmitted(petitionId, msg.sender, commentIndex);
    }
    
    function approveComment(
        uint256 petitionId,
        uint256 commentIndex
    ) external onlyModerator {
        require(commentIndex < petitionComments[petitionId].length, "Invalid index");
        petitionComments[petitionId][commentIndex].approved = true;
        
        emit CommentApproved(petitionId, commentIndex);
    }
    
    function getCommentCount(uint256 petitionId) external view returns (uint256) {
        return petitionComments[petitionId].length;
    }
}
