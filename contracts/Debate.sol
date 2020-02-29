pragma solidity >=0.4.22 <0.7.0;

contract Debateable{
    address creator;
    string text;
    uint subVotes;
    address parent;
    bool isFinalized;

    uint8 public hierarchyLevel;
    uint8 constant MAXHIERARCHYLEVEL = 3;

    uint8 nSubarguments; // 0 means the argument being a leaf
    uint8 nFinalizedSubarguments;

    constructor(address _parent, string memory _text) public{
        creator = msg.sender;
        text = _text;
        subVotes = 0;
        parent = _parent;

        hierarchyLevel = 0;
        nSubarguments = 0;
        nFinalizedSubarguments = 0; // 0 means the argument itself being a leaf

    }
}

/* TODO
- maybe limit to three levels of arguments
-- increase stake with each level? => makes it unattractive to nest arguments to much
*/

contract Debate is Debateable {
    address[] allArguments;

    struct Voter{
        uint8 voteTokens;
        bool joined;
    }
    mapping (address => Voter) public voters;

    function join() external {
        require(!voters[msg.sender].joined, "Joined already.");
        voters[msg.sender].joined = true;
        voters[msg.sender].voteTokens = 9;
    }

    constructor (string memory _text)
    public Debateable(address(this), _text) {
        isFinalized = false;
        hierarchyLevel = 0;
    }

    function payForVote(address voterAddr, uint8 cost) external {
        require(voters[voterAddr].voteTokens >= cost, "Insufficient vote tokens");
        voters[voterAddr].voteTokens -= cost;
    }

    event argumentCreated(address argument, string text, bool supporting);

    function createArgument(address parentArgument, string memory text, bool supporting) public payable {
        require(nSubarguments <= uint(255), "There can't be more than 255 subarguments.");

        address newArgument = address(new Argument(parentArgument, text, address(this), supporting));

        emit argumentCreated(newArgument, text, supporting);

        allArguments.push(newArgument);
        if(parentArgument == address(this))
            nSubarguments += 1;
    }

    function finalize() external {
        nFinalizedSubarguments += 1;

        if(nFinalizedSubarguments == nSubarguments) //TODO careful
            isFinalized = true;
    }
}


/*
send result of each vote to parent - this is shorter and incentives to vote on higher hierarchy arguments or early finalize to save
maybe each argument can maintain a list if all subargs votes have arrived
*/


// How to trigger finalization of leafs ?

contract Argument is Debateable {
    address debateOrigin;
    bool supporting;
    uint votes;

    // This constructor must be assure right subargument call in Debate. Is there a workaround to this?
    constructor(address _parent, string memory _text, address _debateOrigin, bool _supporting)
    public Debateable(address(_parent) , _text) {

        if(address(_parent) == _debateOrigin){
            hierarchyLevel = 1;
        } else {
            Argument parentArgument = Argument(_parent);
            hierarchyLevel = parentArgument.hierarchyLevel();
            require(hierarchyLevel < MAXHIERARCHYLEVEL, "Maximal hiearchy level reached.");
            hierarchyLevel++;
        }

        debateOrigin = _debateOrigin;
        supporting = _supporting;
        votes = 0;
    }

    /*
    Calls the subArgumentIsFinalized() of the next hierarchy
    Can only be called from leafs to ensure traversal from bottom to the top
    */
    function finalize() external {
        require(nSubarguments == 0, "Finalization must start at a leaf.");
        nFinalizedSubarguments += 1;

        if(nFinalizedSubarguments == nSubarguments){
            isFinalized = true;
            if(parent == debateOrigin){
                Debate origin = Debate(debateOrigin);
                origin.finalize();
            } else {

                Argument parentArgument = Argument(parent);
                parentArgument.finalize();
            }
        }
    }

    function addArgument(string memory text, bool _supporting) public payable {
        require(hierarchyLevel <= MAXHIERARCHYLEVEL, "Maximal hiearchy level reached.");
        nSubarguments += 1;
        Debate debate = Debate(debateOrigin);
        debate.createArgument(address(this), text, _supporting);
    }

    function voteAndCost(VOTESTRENGTH vote) internal pure returns(uint8, uint8) {
        if(vote == VOTESTRENGTH.single)
            return (1,1);
        else if(vote == VOTESTRENGTH.double)
            return (2,4);
        else if(vote == VOTESTRENGTH.triple)
            return (3,9);
        else
            revert("Something went ");
    }

    function voteFor(VOTESTRENGTH strength) public payable{
        //votum += int(sqrt(price));

        (uint8 vote, uint8 cost) = voteAndCost(strength);
        Debate debate = Debate(debateOrigin);
        debate.payForVote(msg.sender, cost);
        votes += vote;
    }

    function voteAgainst(VOTESTRENGTH strength) public payable{
        //votum -= int(sqrt(price));

        (uint vote, uint8 cost) = voteAndCost(strength);
        Debate debate = Debate(debateOrigin);
        debate.payForVote(msg.sender, cost);
        votes -= vote;
    }

    enum VOTESTRENGTH{
        single,
        double,
        triple//,four
    }


    //  phases
    enum PHASES{
        edit,stake,
        vote,
        finalize // users have to execute count votes on argumens
    }

}


