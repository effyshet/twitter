// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Twitter {
    // ----- START OF DO-NOT-EDIT ----- //
    struct Tweet {
        uint tweetId;
        address author;
        string content;
        uint createdAt;
    }

    struct User {
        address wallet;
        string name;
        uint[] userTweets;
    }

    mapping(address => User) public users;
    mapping(uint => Tweet) public tweets;
    uint256 public nextTweetId;
    // ----- END OF DO-NOT-EDIT ----- //

    function registerAccount(string calldata _name) external {
        bytes memory tempEmptyStringTest = bytes(_name); 
        require(tempEmptyStringTest.length != 0,"Name cannot be an empty string");
        User memory _recentUser;
        _recentUser.name = _name;
        _recentUser.wallet = msg.sender;
        users[msg.sender] = _recentUser;
    }

    function postTweet(string calldata _content) external accountExists(msg.sender) {     
        Tweet memory _recentTweet;
        _recentTweet.tweetId = nextTweetId;
        _recentTweet.author = msg.sender;
        _recentTweet.content = _content;
        _recentTweet.createdAt = block.timestamp;

        tweets[nextTweetId] = _recentTweet;
        users[msg.sender].userTweets.push(nextTweetId);
        nextTweetId += 1;
    }

    function readTweets(address _user) view external returns(Tweet[] memory) {
        uint[] memory userTweetsId = users[_user].userTweets;
        uint userTweetLength = userTweetsId.length;
        Tweet[] memory userTweets = new Tweet[](userTweetLength);
        uint i;
        for(i = 0; i < userTweetLength; i++) {
            uint tweetId = userTweetsId[i];
            userTweets[i] = tweets[tweetId];
        }
        return userTweets;
    }

    modifier accountExists(address _user) {
        string memory _username = users[_user].name;
        require(bytes(_username).length != 0, "This wallet does not belong to any account.");
        _;
    }

}