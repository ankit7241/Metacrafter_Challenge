// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error NOT_OWNER();
error NOT_BACKER();
error NOT_VALID_AMOUNT();

contract Crowdfunding {
    event Funded(address backer, uint256 amount);
    event Refund(address backer, uint256 amount);
    event GoalAchieved(uint256 finalAmount);

    address private immutable TokenContractAddress;
    address owner;
    uint256 collected;
    uint256 goal;
    mapping(address => uint256) backers;
    address public fundingGoalReceiver;

    constructor(
        uint256 _goal,
        address _fundingGoalReceiver,
        address _TokenContractAddress
    ) {
        if (_goal == 0) {
            revert NOT_VALID_AMOUNT();
        }
        owner = msg.sender;
        goal = _goal;
        fundingGoalReceiver = _fundingGoalReceiver;
        TokenContractAddress = _TokenContractAddress;
    }

    modifier onlyBackers() {
        if (backers[msg.sender] == 0) {
            revert NOT_BACKER();
        }
        _;
    }

    // Function to allow backers to contribute to the project
    function contribute(uint256 _amount) public payable {
        if (_amount == 0) {
            revert NOT_VALID_AMOUNT();
        }
        bool success = IERC20(TokenContractAddress).transferFrom(
            msg.sender,
            address(this),
            _amount
        );
        require(success);
        collected += _amount;
        backers[msg.sender] += _amount;
        // Emit the Funded event
        emit Funded(msg.sender, _amount);
        // If the funding goal is reached, send a success notification to the owner
        if (collected >= goal) {
            bool successful = IERC20(TokenContractAddress).transfer(
                fundingGoalReceiver,
                collected
            );
            require(successful);
            emit GoalAchieved(collected);
        }
    }

    // Function to allow backers to request a refund if the funding goal is not met
    function refund() public onlyBackers {
        // Check if the funding goal is not met
        require(
            collected < goal,
            "Funding goal has been met, no refunds available"
        );

        uint256 refundAmount = backers[msg.sender];
        backers[msg.sender] = 0;
        collected -= refundAmount;
        bool success = IERC20(TokenContractAddress).transfer(
            msg.sender,
            refundAmount
        );
        require(success);
        // Emit the Refund event
        emit Refund(msg.sender, refundAmount);
    }
}
