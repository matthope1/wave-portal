const main = async () => {
	const [owner, randomPerson] = await hre.ethers.getSigners();
  const waveContractFactory = await hre.ethers.getContractFactory('WavePortal');
  const waveContract = await waveContractFactory.deploy({
		value: hre.ethers.utils.parseEther('0.1'),
	});
  await waveContract.deployed();

  console.log("Contract addy:", waveContract.address);
	console.log("Contract deployed by:", owner.address);

	let contractBalance = await hre.ethers.provider.getBalance(
		waveContract.address
	)

	console.log(
		'Contract balance:',
		hre.ethers.utils.formatEther(contractBalance)
	)

	let waveCount;
	let userWaveCount;

	waveCount = await waveContract.getTotalWaves();
	console.log(waveCount.toNumber());

	let waveTxn = await waveContract.wave('A message!');
	await waveTxn.wait();

	waveCount = await waveContract.getTotalWaves();
	console.log(waveCount.toNumber());

	// send wave
	waveTxn = await waveContract.connect(randomPerson).wave('Another message!');
	await waveTxn.wait();

	// get contract balance again
	contractBalance = await hre.ethers.provider.getBalance(
		waveContract.address
	)

	console.log(
		'Contract balance:',
		hre.ethers.utils.formatEther(contractBalance)
	)


	let allWaves = await waveContract.getAllWaves();
	console.log(allWaves)

	waveCount = await waveContract.getTotalWaves();
	waveTxn = await waveContract.connect(randomPerson).wave('Yet Another message!');

	userWaveCount = await waveContract.getUserWaveCount();
	await waveTxn.wait();

	waveCount = await waveContract.getTotalWaves();

	userWaveCount = await waveContract.getUserWaveCount();

	console.log(
		'Contract balance:',
		hre.ethers.utils.formatEther(contractBalance)
	)
	

};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();