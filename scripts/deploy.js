const main = async () => {

  
  const TokenContractFactory = await hre.ethers.getContractFactory('RToken');
  const TokenContract = await TokenContractFactory.deploy();
  await TokenContract.deployed();
  console.log("Contract deployed to:", TokenContract.address);

  const CrowdContractFactory = await hre.ethers.getContractFactory('Crowdfunding');
  const CrowdContract = await CrowdContractFactory.deploy(100,0x61B8A9baFda51De880254d509Aa6B3f12920df25,TokenContract.address);
  await CrowdContract.deployed();
  console.log("Contract deployed to:", CrowdContract.address);

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