pragma solidity ^0.4.24;

import "./lib/Ownable.sol";

contract MPOStorage is Ownable{


	// check if msg.sender is in global approved list of responders
	mapping(address => bool) approvedAddress; 
	// Threshold reached, do not accept any more responses
	mapping(uint256 => uint256) queryStatus;
	// Tally of each response.
	mapping(uint256 => mapping(int => int) ) responseTally; 
	mapping(uint256 => int[]) responseIntArr; 
	mapping(uint256 => int) average;
	// Make sure each party can only submit one response
	mapping(uint256 => mapping(address => bool)) oneAddressResponse; 
	mapping(uint256 => uint256) mpoToClientId;
	
	mapping(uint256 => uint256) precision; 
	mapping(uint256 => uint256) delta; 

	uint256 threshold;
	address[] responders;
	uint256 responderLength = 5;
	// implements Client1
	address client;
	uint256 clientQueryId; 


	// Set Methods / Mutators
	function setThreshold(uint256 _threshold) external onlyOwner {
		threshold = _threshold;
	}

	

	
	function setClientQueryId(uint256 mpoId, uint256 _clientQueryId) external onlyOwner {
		mpoToClientId[mpoId] = _clientQueryId;
	}
 
	function setResponders(address[] parties) external onlyOwner {
		responders=parties;
		for(uint256 i=0; i <responderLength; i++){
			approvedAddress[parties[i]]=true;
		}
	}

	function setQueryStatus(uint queryId, uint256 status) external onlyOwner {
		queryStatus[queryId]=status;
	}

	function tallyResponse(uint256 queryId, int response) external onlyOwner {
		responseTally[queryId][response]++;

	}
	function addIntResponse(uint256 queryId, int256 response, address party) external onlyOwner {
		responseIntArr[queryId].push(response);
		oneAddressResponse[queryId][party] = true;
	}
	function setDelta(uint256 queryId, uint256 _delta) external{
		delta[queryId] = _delta;
	}

	function setPrecision(uint256 queryId, uint256 _precision) external{
		precision[queryId] = _precision;
	}
	// Get Methods / Accessors

	function onlyOneResponse(uint256 queryId, address party) external view returns(bool) {
        return oneAddressResponse[queryId][party];
    }

    function getAddressStatus(address party) external view returns(bool){
        return approvedAddress[party];
    }
	
	function getThreshold() external view returns(uint) { 
		return threshold;
	}
	
	function getTally(uint256 queryId, int256 response)external view returns(int256){
		return responseTally[queryId][response];
	}

	
	function getClientQueryId(uint256 mpoId) external view returns(uint256){
		return mpoToClientId[mpoId];
	}

	function getQueryStatus(uint256 queryId) external view returns(uint256){
		return queryStatus[queryId];
	}

	function getNumResponders() external view returns (uint) {
		return responderLength;
	}

	function getResponderAddress(uint index) external view returns(address){
		return responders[index];
	}
	function getIntResponses(uint256 queryId) external view returns(int[]){
		return responseIntArr[queryId];
	}
	function getDelta(uint256 queryId) external view returns(uint256){
		return delta[queryId];
	}
	function getPrecision(uint256 queryId) external view returns(uint256){
		return precision[queryId];
	}
	
	function getAverage(int[] arr) external view returns(int[]){
		require(arr.length!=0, "Division error");
		int total = 0;
		int length=0;
		for (uint i =0; i<arr.length;i++){
			if(arr[i]!=0){length++;}
			total+=arr[i];
		}
		require(total>arr[0], "Overflow error");
		int[] memory avg = new int[](1);
		avg[0]=total / length;
		return avg;
	}
	

}
