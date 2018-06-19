pragma solidity ^0.4.19;

contract MPOStorage{

	

	
//TODO maybe have a thresholdFull event?
	mapping(uint => string[]) queryResponses;
	mapping(address => bool) approvedAddress;
	
	mapping(uint256 => mapping(string=>uint256) ) responseTally;
	uint256 threshold;
	address[] responders;
	//Set Methods/Mutators

	function setThreshold(uint threshold){
		this.threshold = threshold;
	}
	function setResponders(address[] parties){
		for(int i=0;i<parties.length;i++){
			responders.push(parties[i]);
			approvedAddress[parties[i]]=true;
		}
	}
	function addResponse(uint256 queryId, string response){
		queryResponses[queryId].push(response);
		responseTally[queryId][response]++;
	}

	//Get Methods/Accessors
	function getResponses(uint256 queryId) returns(string[]){
		 return queryResponses[queryId];
	}
	function getThreshold() returns(uint){
		return threshold;
	}
	function getAddressStatus(address party) returns(bool){
		return approvedAddress[party];
	}
	function getTally(uint256 queryId, string response) returns(uint256){
		return responseTally[queryId][response];

	}

}