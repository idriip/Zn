import Nat "mo:base/Nat";
import Principal "mo:base/Principal";

actor FliktDAO {

    // Structure to store movie/show proposals
    type Proposal = {
        id: Nat;
        title: Text;
        description: Text;
        votes: Nat;
        approved: Bool;
    };

    // Structure to store user profiles
    type UserProfile = {
        id: Principal;
        name: Text;
        votingPower: Nat;
    };

    var proposals: [Proposal] = [];
    var users: [UserProfile] = [];
    var adRevenue: Nat = 0;

    // Register a new user
    public func registerUser(name: Text) : async Bool {
        let user = {
            id = Principal.fromActor(this);
            name = name;
            votingPower = 1;
        };
        users := Array.append(users, [user]);
        return true;
    };

    // Create a new proposal
    public func createProposal(title: Text, description: Text) : async Nat {
        let proposalId = Nat.fromInt(proposals.size());
        let newProposal = {
            id = proposalId;
            title = title;
            description = description;
            votes = 0;
            approved = false;
        };
        proposals := Array.append(proposals, [newProposal]);
        return proposalId;
    };

    // Vote on a proposal
    public func voteOnProposal(proposalId: Nat) : async Bool {
        var found = false;
        for (i in Iter.range(0, proposals.size() - 1)) {
            if (proposals[i].id == proposalId) {
                proposals[i].votes := proposals[i].votes + 1;
                if (proposals[i].votes >= 10) {  // Assume 10 votes needed for approval
                    proposals[i].approved := true;
                }
                found := true;
                break;
            }
        };
        return found;
    };

    // Get a proposal by ID
    public query func getProposal(proposalId: Nat) : async ?Proposal {
        for (proposal in proposals.vals()) {
            if (proposal.id == proposalId) {
                return ?proposal;
            }
        };
        return null;
    };

    // Function to add ad revenue
    public func addAdRevenue(amount: Nat) : async Nat {
        adRevenue := adRevenue + amount;
        return adRevenue;
    };

    // Function to allocate funds to an approved proposal
    public func allocateFunds(proposalId: Nat) : async Bool {
        var found = false;
        for (proposal in proposals.vals()) {
            if (proposal.id == proposalId && proposal.approved) {
                // Allocate funds (simplified logic)
                // Here we just print, but in a real scenario, you'd transfer funds
                Debug.print("Funds allocated to proposal: " # proposal.title);
                found := true;
                break;
            }
        };
        return found;
    };

    // Query all proposals
    public query func getAllProposals() : async [Proposal] {
        return proposals;
    };
}
