// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
	uint256 totalWaves;
	uint256 private seed;
	mapping(address => uint256) public userWaveCounts;
	

	event NewWave(address indexed from , uint256 timestamp, string message);

	struct Wave {
		address waver;
		string message;
		uint256 timestamp;
	}

	Wave[] waves;

	mapping(address => uint256) public lastWavedAt;

	constructor() payable {
		console.log("retro was here");
	}

	function wave(string memory _message) public {
		console.log("last waved at", lastWavedAt[msg.sender]);
		require(
			lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
			"Wait 15m"
		);

		lastWavedAt[msg.sender] = block.timestamp;

		totalWaves += 1;
		console.log("%s has waved!", msg.sender);
		userWaveCounts[msg.sender] += 1;

		waves.push(Wave(msg.sender, _message, block.timestamp));
		// geenrate pseudo random number between 0 and 100

		uint256 randomNumber = (block.difficulty + block.timestamp + seed) % 100;
		console.log("Random # generated: %s", randomNumber);

		seed = randomNumber;

		// 50% chance that user wins prize

		if (randomNumber < 50) {
			console.log("%s won!", msg.sender);
			uint256 prizeAmount = 0.0001 ether;
			require(
				prizeAmount <= address(this).balance,
				"Trying to widthdraw more money than the contract has."
			);
			(bool success, ) = (msg.sender).call{value: prizeAmount}("");
			require(success, "Failed to widthdraw money from contrat.");
		}
		emit NewWave(msg.sender, block.timestamp, _message);
	}

	function getAllWaves() public view returns (Wave[] memory){
		return waves;
	}

	function getUserWaveCount() public view returns(uint256) {
		uint256 userWaveCount = userWaveCounts[msg.sender];
		console.log("%s has waved",msg.sender);
		console.log("%d times!", userWaveCount);
		return userWaveCount;
	}

	function getTotalWaves() public view returns (uint256) {
		console.log("We have %d total waves!", totalWaves);
		return totalWaves;
	}
}