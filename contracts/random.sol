//SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";

contract RFSubManager is VRFConsumerBaseV2 {
    VRFCoordinatorV2Interface Coordinator;

    LinkTokenInterface Token;

    address coordinator_contract;

    address token_contract = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;

    bytes32 keyHash;

    uint32 gasLimit;

    uint256 cost;

    uint16 r_confirmations;

    uint32 numwords = 1;

    uint256[] public randomWords;
    uint256 public randomId;
    uint64 public subId;
    address sub_owner;

    constructor(address _coordinator_contract)
        VRFConsumerBaseV2(_coordinator_contract)
    {
        Coordinator = VRFCoordinatorV2Interface(_coordinator_contract);
        Token = LinkTokenInterface(token_contract);
        sub_owner = msg.sender;
        keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
        gasLimit = 100000;
        r_confirmations = 3;
        cost = 150 gwei;
    }

    modifier onlyOwner() {
        require(msg.sender == sub_owner);
        _;
    }

    function requestRandomWords() external onlyOwner {
        require(
            Token.balanceOf(address(this)) > cost,
            "Insufficient Link Tokens"
        );
        randomId = Coordinator.requestRandomWords(
            keyHash,
            subId,
            r_confirmations,
            gasLimit,
            numwords
        );
    }

    function fulfillRandomWords(uint256 _randomId, uint256[] memory randomness)
        internal
        override
    {
        randomWords = randomness;
    }

    function createNewSubscription() external onlyOwner {
        subId = Coordinator.createSubscription();
        Coordinator.addConsumer(subId, address(this));
    }

    function addLinkToken(uint256 amount) external onlyOwner {
        Token.transferAndCall(address(Coordinator), amount, abi.encode(subId));
    }

    function addConsumer(address _consumerAddress) external onlyOwner {
        Coordinator.addConsumer(subId, _consumerAddress);
    }

    function removeConsumer(address _consumerAddress) external onlyOwner {
        Coordinator.removeConsumer(subId, _consumerAddress);
    }

    function cancelSubscription(address _walletAddress) external onlyOwner {
        Coordinator.cancelSubscription(subId, _walletAddress);
        subId = 0;
    }

    function balance(address consumer) public view returns (uint256) {
        return Token.balanceOf(consumer);
    }

    function withdraw(uint256 amount, address to) external onlyOwner {
        Token.transfer(to, amount);
    }
}
