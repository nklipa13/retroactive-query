const axios = require('axios');
const lineReader = require('line-reader');

const url = 'https://gentle-frost-9e74.uniswap.workers.dev/1';
const Web3 = require('web3');


const verifyAddress = async (address) => {
	// if uniswap API return 404, address didn't receive anything on airdrop

	try {
		const response = await axios.get(`${url}/${address}`);
		return false;
	} catch (e) {
		if (e.response.status == 404) {
			return true;
		}
	}
	
} 

(async () => {
	const web3 = new Web3();

	lineReader.eachLine('./defisaver_accounts.json', async function(line, last) {
    	const account = JSON.parse(line);

    	const isOk = await verifyAddress(web3.utils.toChecksumAddress(account.proxy));

    	if (!isOk) {
    		console.log(`${web3.utils.toChecksumAddress(account.proxy)} already got the airdrop`);
    	}

    	if (last) console.log('Finished');
	});
})();

