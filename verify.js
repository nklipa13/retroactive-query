const axios = require('axios');
const lineReader = require('line-reader');

const url = 'https://gentle-frost-9e74.uniswap.workers.dev/1';


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
	lineReader.eachLine('./defisaver_accounts.json', async function(line) {
    	const account = JSON.parse(line);

    	const isOk = await verifyAddress(account.proxy);

    	if (!isOk) {
    		console.log(`${account.proxy} already got the airdrop`);
    	}
	});
})();

