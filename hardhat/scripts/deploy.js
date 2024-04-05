const {ethers} = require("hardhat")

async function main(){
    const metadataURL = "https://ipfs.io/ipfs/"
    const lw3PunksContract = await ethers.deployContract("LW3punks", [metadataURL])

    await lw3PunksContract.waitForDeployment();

    console.log(`LW3Punks contract deployed at address: ${lw3PunksContract.target}`)
}

main()
    .then(()=> process.exit(0))
    .catch((err) => {
        console.error(err)
        process.exit(1)
    })