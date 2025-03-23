const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const multer = require('multer');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5000;

// Configure multeruploadd
const uploadd = multer();

app.use(express.json()); // For parsing application/json
app.use(express.urlencoded({ extended: true })); // For parsing application/x-www-form-urlencoded


app.use(cors());
app.use(bodyParser.json());

// Connect to MongoDB
mongoose.connect('mongodb://127.0.0.1:27017/e_voting', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB connection error:', err));

// User Schema and Model
const userSchema = new mongoose.Schema({
  
  email: { type: String, unique: true }, // Ensure email is unique
  password: String,
  
});

const User = mongoose.model('users', userSchema);





const campaign = new mongoose.Schema({
  

  ppname: String,
  campaigntitle: String,
  campaign: String,
  campaignid:String,
  status:String

});

const Campaign = mongoose.model('campaign', campaign);





const voterSchema = new mongoose.Schema({
  voterId: { type: String, required: true, unique: true },
  voterName: { type: String, required: true },
  password: { type: String, required: true },
  pollingstation_name: { type: String, required: true },
  constituencies_name: { type: String, required: true },
  age: { type: Number, required: true },
  sex: { type: String, enum: ['Male', 'Female'], required: true },
  img: {
    data: Buffer,
    contentType: String,
  },
});

const Voter = mongoose.model('Voter', voterSchema);




const vote = new mongoose.Schema({
  

  userid: { type: String, unique: true },
  politicalparty: String,
  constituency: String,
  candidate:String,
  polingstation:String,
  electionid:String,

});

const votes = mongoose.model('votes', vote);










const candidates = new mongoose.Schema({
  
  candidateid: String,
  candidatesname: String,
  educationlevel: String,
  politicalparty: String,
  constituency: String,
  img: {
    data: Buffer,
    contentType: String,
  },

});

const candidate = mongoose.model('candidate', candidates);






const disputes = new mongoose.Schema({
  
ID:String,
  role: String,
  disputeid: String,
  dispute: String,
  status:String,
  

});

const disputee = mongoose.model('dispute', disputes);






const schedulesSchema = new mongoose.Schema({
  candidateReg: {
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
  },
  electionCampaign: {
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
  },
  voterReg: {
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
  },
  attentionTime: {
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
  },
  voting: {
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
  },
  resultAnnouncement: {
    startDate: { type: Date, required: true },
    endDate: { type: Date, required: true },
  },
});





const electionsSchema = new mongoose.Schema({
  electionId: { type: String, required: true }, 
  electionName: { type: String, required: true }, 
  politicalParties: [{ type: String }], 
  constituencies: [{ type: String }], 
 schedules: schedulesSchema, 
});

const Election = mongoose.model('Election', electionsSchema);








const user_account = new mongoose.Schema({
  ID:{ type: String, unique: true },
  email: { type: String, unique: true }, // Ensure email is unique
  password: String,
  role: String,
  
});

const User_account = mongoose.model('users_accounts', user_account);






const userSchema1 = new mongoose.Schema({
  ID:{ type: String, unique: true },
  name: String,
  email: { type: String, unique: true }, // Ensure email is unique
  password: String,
  img: {
    data: Buffer,
    contentType: String,
  },
});





const schedule = new mongoose.Schema({
   scheduleid: String,
   title: String,
  started_date:String, 
  ended_date: String,
  status : String,
  description: String,
});
const schedules = mongoose.model('Schedules', schedule);



const announcementSchema = new mongoose.Schema({
  announcement: { type: String, required: true },
  pid: { type: String, required: true },
  pdate: { type: Date, default: Date.now },
  images: [
    {
      data: Buffer,
      contentType: String,
    },
  ],
  selectedOptions: { type: [String], default: [] }, // New field for selected options
});

// Create the model
const addannounce = mongoose.model('Announcement', announcementSchema);



const Users = mongoose.model('politicalparty', userSchema1);
// User Registration Endpoint


//constituencies
const constituencySchema = new mongoose.Schema({
  ID: { type: String, required: true ,unique: true },
  name: { type: String, required: true ,unique: true },
  region: { type: String, required: true },
  description: { type: String, required: true },
  password:  String, // Consider using hashing for passwords
  email: { type: String, required: true, unique: true }
});

const constituencyy = mongoose.model('constituencies', constituencySchema);
 
const pollingstation = new mongoose.Schema({
  ID:{ type: String, unique: true },
  name: { type: String, required: true ,unique: true },
  constituencies_name: { type: String, required: true },
 description: { type: String, required: true },
 password: { type: String, required: true },
 email : { type: String, required: true,unique: true },
 wereda: { type: String, required: true },
 kebele : { type: String, required: true },
});
const pollingstations = mongoose.model('pollingstation', pollingstation);









app.get('/ballot/:electionId', async (req, res) => {
  const electionId = req.params.electionId;
  console.log(`Election ID: ${electionId}`);

  try {
      // Fetch the election document based on electionId
      const election = await Election.findOne({ electionId });
      if (!election) return res.status(404).send('Election not found.');

      // Fetch political parties associated with this election
      const parties = await Users.find({ name: { $in: election.politicalParties } });
      
      // Fetch candidates within the constituencies related to this election
      const candidates = await candidate.find({ constituency: { $in: election.constituencies } });

      console.log('Parties:', parties);
      console.log('Candidates:', candidates);

      // Map candidates to a response format
      const ballot = candidates.map(candidate => {
          const party = parties.find(p => p.name === candidate.politicalparty); // Match with politicalparty
          console.log(`Candidate Name: ${candidate.candidatesname}`); // Log candidate name

          return {
              candidateName: candidate.candidatesname || 'Unknown Candidate',
              candidateImage: candidate.img && candidate.img.data && Buffer.isBuffer(candidate.img.data) 
                  ? {
                      data: candidate.img.data.toString('base64'), // Convert image buffer to base64
                      contentType: candidate.img.contentType,
                  } 
                  : null,
              politicalPartyName: party ? party.name : 'Unknown Party',
              politicalPartyImage: party && party.img && party.img.data && Buffer.isBuffer(party.img.data) 
                  ? {
                      data: party.img.data.toString('base64'), // Convert party image buffer to base64
                      contentType: party.img.contentType,
                  } 
                  : null,
          };
      });

      // Include voting start and end dates from the election schema
     

      // Send response including candidates and voting info
      res.json({ ballot});
  } catch (error) {
      console.error('Error retrieving ballot:', error);
      res.status(500).send('Server Error');
  }
});







//const multer = require('multer');
//const upload = multer();









// Route to fetch all voters
app.get('/voterss', async (req, res) => {
  const { userId } = req.query;
  console.log(`User ID: ${userId}`); // Get userId from query parameters

  if (!userId) {
    return res.status(400).json({ message: 'User ID is required' });
  }

  try {
    // Find the polling station associated with the userId
    const pollingStation = await pollingstations.findOne({ ID: userId });

    if (!pollingStation) {
      return res.status(404).json({ message: 'Polling station not found for this user' });
    }

    const pollingStationName = pollingStation.name; // Get polling station name
    console.log(`Polling Station: ${pollingStationName}`);

    // Find voters associated with this polling station name
    const voters = await Voter.find({ pollingstation_name: pollingStationName });

    // Optionally transform the voters' data to include only necessary fields
    const voterData = voters.map(voter => ({
      voterId: voter.voterId,
      voterName: voter.voterName,
      age: voter.age,
      sex: voter.sex,
      
pollingstation_name: 
voter.pollingstation_name,
constituencies_name: voter.constituencies_name,
      img: voter.img && voter.img.data && Buffer.isBuffer(voter.img.data) ? {
        data: voter.img.data.toString('base64'), // Convert Buffer to base64 string
        contentType: voter.img.contentType,
      } : null,// This will be the Base64 string
    }));
    return res.status(200).json({ status: true, data: voterData });
  
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: 'Failed to fetch voters', error });
  }
});












app.post('/vote', async (req, res) => {
  const { userid, politicalparty, candidate,  electionid } = req.body;

  try {
    // Check if the user has already voted
    const existingVote = await votes.findOne({ userid });
    const existingVoter = await Voter.findOne({voterId: userid });
    const pollyname = existingVoter.pollingstation_name;
    const constiname = existingVoter.constituencies_name;
console.log(`${pollyname}`)
console.log(`${constiname}`)
    if (existingVote) {
      return res.status(400).json({ message: 'You have already voted.' });
    }

    const newVote = new votes({
      userid,
      politicalparty,
      constituency:constiname,
      candidate,
      polingstation:pollyname,
      electionid,
    });

    await newVote.save();
    return res.status(200).json({ message: 'Vote recorded successfully!' });
  } catch (error) {
    return res.status(500).json({ message: 'Error recording vote', error });
  }
});





app.get('/candidatescount', async (req, res) => {
  try {
    const { electionId } = req.query; // Get the electionId from query parameters
    if (!electionId) {
      return res.status(400).json({ error: 'Election ID is required.' });
    }

    console.log(`Fetching candidates for election ID: ${electionId}...`);

    // Fetch votes for this specific election ID
    const candidates = await votes.find({ electionid: electionId });
    console.log(`Fetched candidates: ${JSON.stringify(candidates)}`);

    // Skip if there are no candidates
    if (!candidates || candidates.length === 0) {
      console.log(`No candidates found for election ID: ${electionId}.`);
      return res.json([]); // Return an empty array if no candidates found
    }

    // Group votes by constituency
    const constituencyResults = {};

    candidates.forEach(vote => {
      const constituency = vote.constituency; // Get constituency from the vote
      const name = vote.candidate; // Get the candidate's name
      const party = vote.politicalparty; // Get the political party name

      // Initialize constituency results if it doesn't exist
      if (!constituencyResults[constituency]) {
        constituencyResults[constituency] = {
          totalVotes: 0,
          candidateCount: {},
          winner: null,
          message: ''
        };
      }

      // Count occurrences of each candidate and total votes
      const candidateKey = `${name} (${party})`; // Create a unique key for each candidate including party
      constituencyResults[constituency].candidateCount[candidateKey] = 
          (constituencyResults[constituency].candidateCount[candidateKey] || 0) + 1; // Increment count for this candidate
      constituencyResults[constituency].totalVotes++; // Increment total votes
    });

    // Prepare the response for each constituency
    const results = Object.keys(constituencyResults).map(constituency => {
      const { totalVotes, candidateCount } = constituencyResults[constituency];
      
      // Convert the candidateCount object to an array for better readability
      const response = Object.entries(candidateCount).map(([candidateKey, count]) => {
        const [name, party] = candidateKey.split(' ('); // Split name and party
        return { name, party: party.slice(0, -1), count }; // Remove the closing parenthesis
      });

      // Determine the winner for this constituency
      let winner = null;
      let maxVotes = 0;
      let tie = false;

      Object.entries(candidateCount).forEach(([candidateKey, count]) => {
        if (count > maxVotes) {
          maxVotes = count;
          const [name, party] = candidateKey.split(' (');
          winner = { name, party: party.slice(0, -1), count }; // Set winner name, party, and votes
          tie = false; // Reset tie
        } else if (count === maxVotes) {
          tie = true; // Found a tie
        }
      });

      // Build the result for this constituency
      const result = {
        constituency,
        totalVotes,
        candidates: response,
        winner: tie ? { name: 'Tie', party: '', count: maxVotes } : winner,
        message: tie
          ? `In ${constituency}, there is a tie between the candidates with ${maxVotes} votes.`
          : `In ${constituency}, the winner is ${winner.name} from ${winner.party} with ${winner.count} votes.`
      };

      return result; // Return the result for this constituency
    });

    res.json(results); // Respond with the results for all constituencies
  } catch (error) {
    console.error('Error fetching candidate counts:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});




app.put('/updatecampaign/:campaignid', async (req, res) => {
  const { campaignid } = req.params;
  const { campaigntitle, campaign } = req.body;

  if (!campaigntitle || !campaign) {
    return res.status(400).json({ message: 'All fields must be filled out.' });
  }

  try {
    const updatedCampaign = await Campaign.findOneAndUpdate(
      { campaignid: campaignid },
      { campaigntitle, campaign },
      { new: true } // Return the updated document
    );

    if (!updatedCampaign) {
      return res.status(404).json({ message: 'Campaign not found.' });
    }

    res.status(200).json(updatedCampaign);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to update campaign.', error: error.message });
  }
});




app.put('/updatedispute/:disputeid', async (req, res) => {
  const { disputeid } = req.params;
  const { dispute } = req.body;

  if (!dispute) {
    return res.status(400).json({ message: 'Dispute field must be filled out.' });
  }

  try {
    const updatedDispute = await disputee.findOneAndUpdate(
      { disputeid: disputeid },
      { dispute },
      { new: true } // Return the updated document
    );

    if (!updatedDispute) {
      return res.status(404).json({ message: 'Dispute not found.' });
    }

    res.status(200).json(updatedDispute);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Failed to update dispute.', error: error.message });
  }
});






app.post('/login', async (req, res) => {
  const { ID, password } = req.body;

  if (!ID || !password) {
    return res.status(400).json({ status: false, message: 'Please provide all fields' });
  }

  try {
    // Find the user by email
    const existingUser = await User_account.findOne({ ID });
    
    if (!existingUser) {
      return res.status(400).json({ status: false, message: 'User does not exist' });
    }

    // Compare the provided password with the stored hashed password
    const isPasswordValid = await bcrypt.compare(password, existingUser.password);
       
    if (!isPasswordValid) {
      return res.status(400).json({ status: false, message: 'Invalid password' });
    }

    // Optionally, generate a token for the user here
    const role =  existingUser.role;
    return res.status(200).json({ status: true, message: role });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});



app.post('/registerpollingstation', async (req, res) => {
  const { ID,name,email , description, password,constituencies_name, wereda, kebele} = req.body;
console.log(`${ID}  ${name} ${email}${description} ${password} ${constituencies_name} ${wereda} ${kebele}`);
console.log(`${ID}`);
  if (!email || !password  ||!name) {
    return res.status(400).json({ status: false, message: 'Please provide all fields' });
  }


  const hashedPassword = await bcrypt.hash(password, 10);


  try {
    const existingUser = await pollingstations.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ status: false, message: 'constituency email exists' });
    }



    const existingUseraccount = await User_account.findOne({ email });
    if (existingUseraccount) {
      return res.status(400).json({ status: false, message: 'email exists' });
    }

    const role="Polling Station";


    const existingname = await pollingstations.findOne({ name });
    if (existingname) {
      return res.status(400).json({ status: false, message: 'constituencyy name exists' });
    }


    const constituency = new pollingstations({ ID,name,constituencies_name,description,password:hashedPassword,email , wereda , kebele });
    await constituency.save();

    const useraccount = new User_account({ ID,email,password:hashedPassword, role });
    await useraccount.save();

    res.status(201).json({ message: 'Constituency registered successfully!' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});



app.post('/postcampaign', async (req, res) => {
  const { ppname ,campaigntitle, campaign, campaignid,} = req.body;

  if (!ppname ||!campaigntitle|| !campaign  ||!campaignid) {
    return res.status(400).json({ status: false, message: 'Please provide alll fields' });
  }


 


  try {
    
    const camp = await Users.findOne({ ID: ppname }); 
    const name = camp.name; 
    const status="active";


    


    const cam = new Campaign({ ppname:name ,campaigntitle, campaign, campaignid,status:status });
    await cam.save();

    

    res.status(201).json({ message: 'Constituency registered successfully!' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});









app.post('/postdispute', async (req, res) => {
  const { ppname ,dispute, disputeid,} = req.body;

  if (!ppname ||!dispute|| !disputeid ) {
    return res.status(400).json({ status: false, message: 'Please provide alll fields' });
  }


 


  try {
    
    const camp = await User_account.findOne({ ID: ppname }); 
    const name = camp.role; 
    const status="active";


    


    const cam = new disputee({ ID:ppname ,role:name , disputeid,dispute,status:status });
    await cam.save();

    

    res.status(201).json({ message: 'Dispute Send successfully!' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});







app.post('/addelection', async (req, res) => {
  const { electionId ,electionName, politicalParties,constituencies,schedules} = req.body;

 


 console.log(`${schedules}`)


  try {
    
 


    


    const cam = new Election({ electionId ,electionName , politicalParties,constituencies ,schedules});
    await cam.save();

    

    res.status(201).json({ message: 'Dispute Send successfully!' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});





app.post('/registerConstituency', async (req, res) => {
  const { ID,name, region, description, password, email } = req.body;
console.log("greate");
console.log(`${email}`);
  if (!email || !password || !region ||!name) {
    return res.status(400).json({ status: false, message: 'Please provide all fields' });
  }


  const hashedPassword = await bcrypt.hash(password, 10);

  try {
    const existingUser = await constituencyy.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ status: false, message: 'constituency email exists' });
    }

    const existingname = await constituencyy.findOne({ name });
    if (existingname) {
      return res.status(400).json({ status: false, message: 'constituencyy name exists' });
    }

    const existingUseraccount = await User_account.findOne({ email });
    if (existingUseraccount) {
      return res.status(400).json({ status: false, message: 'email exists' });
    }

    const role="Constituency";
    console.log(`${role} ${name} ${region} ${description} ${hashedPassword} ${email}`);

   const constituency = new constituencyy({ ID,name, region, description, password: hashedPassword, email });
    await constituency.save();

    const useraccount = new User_account({ ID,email,password: hashedPassword, role });
    await useraccount.save();

    res.status(201).json({ message: 'Constituency registered successfully!' });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});





app.use(express.json());

app.use(express.urlencoded({ extended: true }));

app.post('/addschedule', uploadd.none(), async (req, res) => {

  const { scheduleid,title,started_date,ended_date,status,description } = req.body;

 



  if (!title || !started_date ||!scheduleid||!ended_date||!status||!description) {
    return res.status(400).json({ status: false, message: 'Please provide all fields' });
  }

  try {
    
    const newUser = new schedules({
      scheduleid,
      title,
      started_date,
      ended_date,
      status,
      description

    });

    await newUser.save();
    return res.status(201).json({ status: true, message: 'User registered successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});



app.get('/schedules', async (req, res) => {
  try {
    const scheduless = await schedules.find(); // Assuming Schedule is your Mongoose model
    res.json(scheduless);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});


// Configure multer for image uploads
const storage = multer.memoryStorage();
const upload = multer({
  storage: storage,
  limits: {
    fileSize: 20 * 1024 * 1024, // Limit file size to 5 MB
    fieldSize: 4 * 1024 * 1024, // Limit each field to 2 MB
  },
});

// Political Party Registration Endpoint
app.post('/registerpoliticalparty', upload.single('image'), async (req, res) => {
  const { ID,name, email, password } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({ status: false, message: 'Please provide all fields' });
  }

  try {
    // Check if user already exists
    const existingUser = await Users.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ status: false, message: 'User already exists' });
    }


    const existingUseraccount = await User_account.findOne({ email });
    if (existingUseraccount) {
      return res.status(400).json({ status: false, message: 'email exists' });
    }

    const role="Political Party";
    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new political party user
    const newUsers = new Users({
      ID,
      name,
      email,
      password: hashedPassword,
      img: req.file ? {
        data: req.file.buffer,
        contentType: req.file.mimetype,
      } : undefined,
    });

    await newUsers.save();


    const useraccount = new User_account({ ID,email,password:hashedPassword, role });
    await useraccount.save();

    return res.status(201).json({ status: true, message: 'Political party registered successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});








app.post('/registervoter', upload.single('image'), async (req, res) => {
  console.log('Request Body:', req.body); // Log the incoming request body
  const { voterId, voterName, password, age, sex, userId, image } = req.body;
 // const { voterId, voterName, password, age, sex, userId,image,  } = req.body;
console.log(`${userId}`)

const pollingStation = await pollingstations.findOne({ ID: userId });

if (!pollingStation) {
  console.error('Polling station not found');
  return res.status(404).json({ message: 'Polling station not found' });
}

const pollingStationName = pollingStation.name;
const constituencyName = pollingStation.constituencies_name;
const hashedPassword = await bcrypt.hash(password, 10);

console.log(`${pollingStationName}`);
console.log(`${constituencyName}`);
  try {
    const newVoter = new Voter({
      voterId,
      voterName,
      password:hashedPassword,
      constituencies_name:constituencyName,
      pollingstation_name:pollingStationName,
      age,
      sex,
      img: req.file ? {
        data: req.file.buffer,
        contentType: req.file.mimetype,
      } : undefined, // Store image as Base64 directly from the request body
      //userId, // Include userId in the voter registration
    });
    await newVoter.save();

    const role="Voter";

    const useraccount = new User_account({ ID:voterId,email:voterId,password:hashedPassword, role });
    await useraccount.save();
    res.status(201).json({ message: 'Voter registered successfully' });
  } catch (error) {
    console.error(error);
    res.status(400).json({ message: 'Failed to register voter', error });
  }
});







app.post('/registercandidate', upload.single('image'), async (req, res) => {
  const { candidateid,candidatesname, educationlevel,politicalparty, constituency } = req.body;
console.log(`${candidateid} ${candidatesname} ${educationlevel} ${politicalparty} ${constituency}`);
  if (!candidateid || !candidatesname || !politicalparty) {
    return res.status(400).json({ status: false, message: 'Please provide all fields' });
  }

  try {
    // Check if user already exists
    const existingUser = await candidate.findOne({ candidateid });
    if (existingUser) {
      return res.status(400).json({ status: false, message: 'User already exists' });
    }


    
   



    // Create a new political party user
    const newUsers = new candidate({
      candidateid,
      candidatesname,
      educationlevel,
      politicalparty,
      constituency,
      img: req.file ? {
        data: req.file.buffer,
        contentType: req.file.mimetype,
      } : undefined,
    });

    await newUsers.save();


  

    return res.status(201).json({ status: true, message: 'Political party registered successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});







app.post('/addannouncement', upload.array('images'), async (req, res) => {
  const { announcement, pid, selected_options } = req.body;

  if (!announcement || !pid) {
    return res.status(400).json({ status: false, message: 'Please provide all fields' });
  }

  try {
    // Create a new announcement
    const newAnnouncement = new addannounce({
      announcement,
      pid,
      selectedOptions: selected_options ? selected_options.split(', ') : [], // Split and store as array
      images: req.files ? req.files.map(file => ({
        data: file.buffer,
        contentType: file.mimetype,
      })) : [],
    });

    await newAnnouncement.save();
    return res.status(201).json({ status: true, message: 'Announcement posted successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});



// Fetch all political parties
// Fetch all political parties
app.get('/politicalparties', async (req, res) => {
  console.log(`we`)
  try {
    const parties = await Users.find(); // Fetch all political parties
    const partiesWithImages = parties.map(party => ({
      name: party.name,
      email: party.email,
      img: party.img && party.img.data && Buffer.isBuffer(party.img.data) ? {
        data: party.img.data.toString('base64'), // Convert Buffer to base64 string
        contentType: party.img.contentType,
      } : null,
    }));
    return res.status(200).json({ status: true, data: partiesWithImages });
  } catch (error) {
    console.error('Error fetching political parties:', error); // More specific error logging
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});








app.get('/candidates', async (req, res) => {
  try {
    console.log(`mo`)
    const candi = await candidate.find(); // Fetch all political parties
    const candiWithImages = candi.map(can => ({
      candidateid: can.candidateid,
      candidatename: can.
      candidatesname,
      educationlevel: can.educationlevel,
      politicalparty: can.politicalparty,
      constituency: can.constituency,
      img: can.img && can.img.data && Buffer.isBuffer(can.img.data) ? {
        data: can.img.data.toString('base64'), // Convert Buffer to base64 string
        contentType: can.img.contentType,
      } : null,
    }));
    console.log(`${candiWithImages}`)
    return res.status(200).json({ status: true, data: candiWithImages });
  } catch (error) {
    console.error('Error fetching political parties:', error); // More specific error logging
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});






app.get('/candidatess/:ID', async (req, res) => {
  const ID=req.params.ID;
  console.log(`${ID}`)
  try {
    console.log(`rr`)
    const name = await Users.findOne({ID:ID}); 
    console.log(`${name.name}`)
    const pp=name.name;
    const candi = await candidate.find({politicalparty:pp}); // Fetch all political parties
    const candiWithImages = candi.map(can => ({
      candidateid: can.candidateid,
      candidatename: can.
      candidatesname,
      educationlevel: can.educationlevel,
      politicalparty: can.politicalparty,
      constituency: can.constituency,
      img: can.img && can.img.data && Buffer.isBuffer(can.img.data) ? {
        data: can.img.data.toString('base64'), // Convert Buffer to base64 string
        contentType: can.img.contentType,
      } : null,
    }));
    console.log(`${candiWithImages}`)
    return res.status(200).json({ status: true, data: candiWithImages });
  } catch (error) {
    console.error('Error fetching political parties:', error); // More specific error logging
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});







app.get('/candidatesss/:politicalparty', async (req, res) => {
  const politicalparty=req.params.politicalparty;
  console.log(`${politicalparty}`)
  try {
    console.log(`rr`)
   
    const candi = await candidate.find({politicalparty:politicalparty}); // Fetch all political parties
    const candiWithImages = candi.map(can => ({
      candidateid: can.candidateid,
      candidatename: can.
      candidatesname,
      educationlevel: can.educationlevel,
      politicalparty: can.politicalparty,
      constituency: can.constituency,
      img: can.img && can.img.data && Buffer.isBuffer(can.img.data) ? {
        data: can.img.data.toString('base64'), // Convert Buffer to base64 string
        contentType: can.img.contentType,
      } : null,
    }));
    console.log(`${candiWithImages}`)
    return res.status(200).json({ status: true, data: candiWithImages });
  } catch (error) {
    console.error('Error fetching political parties:', error); // More specific error logging
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});






app.get('/Constituency', async (req, res) => {
  try {
    console.log('here')
    const Constituency = await constituencyy.find(); 
   // console.log('Fetched Constituencies:', Constituency);
    console.log('here1')
    res.json(Constituency);
    console.log('here2')
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});







app.get('/pp', async (req, res) => {
  try {
    console.log('here')
    const Constituency = await constituencyy.find(); 
   // console.log('Fetched Constituencies:', Constituency);
    console.log('here1')
    res.json(Constituency);
    console.log('here2')
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});





app.get('/pp1', async (req, res) => {
  try {
    console.log('here')
    const Constituency = await Users.find(); 
   // console.log('Fetched Constituencies:', Constituency);
    console.log('here1')
    res.json(Constituency);
    console.log('here2')
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});



app.get('/pollingstation', async (req, res) => {
  try {
    console.log('here')
    const pollingstationn = await pollingstations.find(); 
    console.log('Fetched Constituencies:', pollingstationn);
    console.log('here1')
    res.json(pollingstationn);
    console.log('here2')
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});





app.get('/pollingstation4', async (req, res) => {
  const userId = req.query.userId; // Get userId from query parameters

  try {
    // Step 1: Find the constituency associated with the userId
    const constituency = await constituencyy.findOne({ ID: userId }); // Adjust your query as needed

    if (!constituency) {
      return res.status(404).json({ message: 'Constituency not found for this user.' });
    }

    const constituencyName = constituency.name; // Get the constituency name

    // Step 2: Find polling stations that match the constituency name
    const pollingStations = await pollingstations.find({
      constituencies_name: constituencyName // Assuming 'constituencies_name' is the field in your polling station collection
    });

    console.log('Fetched Polling Stations:', pollingStations);
    res.json(pollingStations); // Send the list of polling stations as the response

  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});





app.get('/campaign/:userId', async (req, res) => {
  console.log(`oooo`);
  const { userId } = req.params; // Extract ID from the request parameters
  console.log(`Received ID: ${userId}`);

  try {
      console.log('here');
      const camp = await Users.findOne({ ID: userId }); // Ensure this field matches your database schema

      // Check if camp is null
      if (!camp) {
          return res.status(404).json({ message: 'User not found' });
      }

      const name = camp.name; // This line will only execute if camp is not null
      console.log(`User name: ${name}`);

      const camp1 = await Campaign.find({ ppname: name }); // Ensure ppname is correct
      console.log('Fetched Constituencies:', camp1);
      console.log('here1');
      res.json(camp1); // Send the fetched campaigns back
      console.log('here2');
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Server error' });
  }
});




app.get('/campaignn/:ppname', async (req, res) => {
  console.log(`aaaaaaa`);
  const { ppname } = req.params; // Extract ID from the request parameters
  console.log(`Received ID: ${ppname}`);

  try {
     
      

      const camp1 = await Campaign.find({ ppname: ppname }); // Ensure ppname is correct
     
      res.json(camp1); // Send the fetched campaigns back
      console.log('here2');
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Server error' });
  }
});


app.get('/dispute', async (req, res) => {


  try {

      const camp1 = await disputee.find(); // Ensure ppname is correct
     
      res.json(camp1); // Send the fetched campaigns back
      console.log('here2');
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Server error' });
  }
});





app.get('/elections', async (req, res) => {
  try {
    console.log(`aaaaaa`)
    const elections = await Election.find(); // Fetch all elections
    res.status(200).json(elections); // Send the elections data
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});



app.get('/elections/:electionId', async (req, res) => {
  const electionId=req.params.electionId;
  try {
    console.log(`aaaaaa`)
    const elections = await Election.find({electionId}); // Fetch all elections
    res.status(200).json(elections); // Send the elections data
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});


app.get('/dispute/:userId', async (req, res) => {
  console.log(`aaaaaaa`);
  const { userId } = req.params; // Extract ID from the request parameters
  console.log(`Received ID: ${userId}`);

  try {
      console.log('here');
    //  const camp = await Users.findOne({ ID: userId }); // Ensure this field matches your database schema

      // Check if camp is null
     // if (!camp) {
       //   return res.status(404).json({ message: 'User not found' });
    //  }

      //const name = camp.name; // This line will only execute if camp is not null
     // console.log(`User name: ${name}`);

      const camp1 = await disputee.find({ ID: userId }); // Ensure ppname is correct
      console.log('Fetched dispute:', camp1);
      console.log('here1');
      res.json(camp1); // Send the fetched campaigns back
      console.log('here2');
  } catch (error) {
      console.error(error);
      res.status(500).json({ message: 'Server error' });
  }
});








app.get('/countparties', async (req, res) => {
  const count = await Users.countDocuments();
  res.json({ count });
});




app.get('/countvoter', async (req, res) => {
 // const count = await voters.countDocuments();
  //res.json({ count });
});


app.get('/countconstituency', async (req, res) => {
  const count = await constituencyy.countDocuments();
  res.json({ count });
});



app.get('/countpollingstation', async (req, res) => {
  const count = await pollingstations.countDocuments();
  res.json({ count });
});



app.get('/countpollingstation/:constituencies_name', async (req, res) => {
  const { constituencies_name } = req.params;
  console.log(`${constituencies_name}`)
  try {
   // const constituencyName = req.query.constituencyName; // Get the constituency name from the query parameters
    const count = await pollingstations.countDocuments({ constituencies_name: constituencies_name }); // Count documents based on constituency name
    res.json({ count });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});



app.put('/political_party/update', upload.single('img'), async (req, res) => {
  const email = req.query.email;
  const name = req.query.name;

  if (!email) {
      return res.status(400).send('Email is required');
  }

  //console.log(`Attempting to update party with email: ${email} and name: ${name}`);

  try {
      const result = await Users.updateOne(
          { email },
          {
              $set: {
                  name: name,
                  img: req.file ? {
                      data: req.file.buffer,
                      contentType: req.file.mimetype,
                  } : undefined,
              }
          }
      );

      console.log(`Update result: ${JSON.stringify(result)}`);

      if (result.modifiedCount === 0) {
          return res.status(404).send('Party not found or no changes made');
      }
      res.status(200).send('Party information updated successfully');
  } catch (error) {
      console.error('Error updating party:', error);
      res.status(500).send('Internal Server Error');
  }
});








app.delete('/schedule/delete/:scheduleid', async (req, res) => {
  const { scheduleid } = req.params; // Use params to get scheduleid

  if (!scheduleid) {
    return res.status(400).send('Schedule ID is required');
  }

  console.log(`Attempting to delete schedule with ID: ${scheduleid}`);

  try {
    const result = await schedules.deleteOne({ scheduleid });

    console.log(`Delete result: ${JSON.stringify(result)}`);

    if (result.deletedCount === 0) {
      return res.status(404).send('Schedule not found or no changes made');
    }
    res.status(200).send('Schedule deleted successfully');
  } catch (error) {
    console.error('Error deleting schedule:', error);
    res.status(500).send('Internal Server Error');
  }
});
















app.delete('/campaign/delete/:campaignid', async (req, res) => {
  console.log(`nnnnnnnnnnnnnnnn`)
  const { campaignid } = req.params; // Use params to get scheduleid

  if (!campaignid) {
    return res.status(400).send('Schedule ID is required');
  }

  console.log(`Attempting to delete schedule with ID: ${campaignid}`);

  try {
    const result = await Campaign.deleteOne({ campaignid });

    console.log(`Delete result: ${JSON.stringify(result)}`);

    if (result.deletedCount === 0) {
      return res.status(404).send('Schedule not found or no changes made');
    }
    res.status(200).send('Schedule deleted successfully');
  } catch (error) {
    console.error('Error deleting schedule:', error);
    res.status(500).send('Internal Server Error');
  }
});








app.delete('/dispute/delete/:disputeid', async (req, res) => {
  console.log(`nnnnnnnnnnnnnnnn`)
  const { disputeid } = req.params; // Use params to get scheduleid

  if (!disputeid) {
    return res.status(400).send('Schedule ID is required');
  }

  console.log(`Attempting to delete schedule with ID: ${disputeid}`);

  try {
    const result = await disputee.deleteOne({ disputeid });

    console.log(`Delete result: ${JSON.stringify(result)}`);

    if (result.deletedCount === 0) {
      return res.status(404).send('Schedule not found or no changes made');
    }
    res.status(200).send('Schedule deleted successfully');
  } catch (error) {
    console.error('Error deleting schedule:', error);
    res.status(500).send('Internal Server Error');
  }
});














app.delete('/news/delete/:pid', async (req, res) => {
  const { pid } = req.params; // Use params to get scheduleid

  if (!pid) {
    return res.status(400).send('Schedule ID is required');
  }

  console.log(`Attempting to delete schedule with ID: ${pid}`);

  try {
    const result = await addannounce.deleteOne({ pid });

    console.log(`Delete result: ${JSON.stringify(result)}`);

    if (result.deletedCount === 0) {
      return res.status(404).send('Schedule not found or no changes made');
    }
    res.status(200).send('Schedule deleted successfully');
  } catch (error) {
    console.error('Error deleting schedule:', error);
    res.status(500).send('Internal Server Error');
  }
});



app.put('/updateSchedule/:scheduleid', async (req, res) => {
   const { scheduleid } = req.params;
    const { title, started_date, ended_date, description } = req.body;
  //console.log(`Attempting to update schedule with ID: ${scheduleid}  ${description}  ${ended_date}  ${started_date}  ${title}`);


  

  try {
    const updatedSchedule = await schedules.findOneAndUpdate(
      {
        scheduleid: scheduleid },
      { $set: { title: title, 
        started_date : started_date, 
        ended_date :ended_date,
         description : description}},
      { new: true } // Return the updated document
    );

    if (!updatedSchedule) {
      return res.status(404).json({ message: 'Schedule not found' });
    }

    res.json({ message: 'Schedule updated successfully', updatedSchedule });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error updating schedule', error });
  }
});







app.put('/updateConstituency/:ID', async (req, res) => {
  const { ID } = req.params;
   const { name,email, region, description} = req.body;
 console.log(`Attempting to update schedule with ID: ${ID}  ${name}  ${email}  ${region}  ${description}`);


 

 try {
   const updatedConstituency = await constituencyy.findOneAndUpdate(
     {
       ID: ID },
     { $set: {
      name: name,
       email: email, 
       region: region, 
        description : description}},
     { new: true } // Return the updated document
   );

   if (!updatedConstituency) {
     return res.status(404).json({ message: 'Schedule not found' });
   }

   res.json({ message: 'Schedule updated successfully', updatedConstituency });
 } catch (error) {
   console.error(error);
   res.status(500).json({ message: 'Error updating schedule', error });
 }
});






app.delete('/political_party/delete',  async (req, res) => {
  const email = req.query.email;
  

  if (!email) {
      return res.status(400).send('Email is required');
  }

  console.log(`Attempting to update party with email: ${email}`);

  try {
      const result = await Users.deleteOne(
          { email }
         
      );

      const resultt = await User_account.deleteOne(
        { email }
       
    );

      console.log(`Update result: ${JSON.stringify(result)}`);

      if (result.deletedCount === 0) {
          return res.status(404).send('Party not found or no changes made');
      }
      res.status(200).send('Party information updated successfully');
  } catch (error) {
      console.error('Error updating party:', error);
      res.status(500).send('Internal Server Error');
  }
});





app.delete('/Constituency/delete', async (req, res) => 
  { const email = req.query.email; 
    if (!email) { return res.status(400).send('Name is required');

     } 
     console.log(`Attempting to delete constituency with name: ${email}`);
      try {
         const result = await constituencyy.deleteOne({email}); 
         const resultt = await User_account.deleteOne(
          { email }
         
      );
         console.log(`Delete result: ${JSON.stringify(result)}`); 
         if (result.deletedCount === 0) {
           return res.status(404).send('Constituency not found or no changes made');
           } 
           res.status(200).send('Constituency deleted successfully');
           }
            catch (error) { 
              console.error('Error deleting constituency:', error); 
              res.status(500).send('Internal Server Error'); 
            } 
          });







app.get('/announcements', async (req, res) => {
  try {
    const announcements = await addannounce.find();
    const response = announcements.map(announcement => ({
      pdate:announcement.pdate,
      id: announcement.pid,
      announcement: announcement.announcement,
      images: announcement.images.map(img => ({
        data: img.data.toString('base64'),
        contentType: img.contentType,
      })),
    }));
    res.status(200).json(response);
  } catch (error) {
    console.error(error);
    res.status(500).json({ status: false, message: 'Server error' });
  }
});



app.get('/aannouncements', async (req, res) => {
  //const { options } = req.query; // Access query parameter
//console.log(`${options}`)
  // Check if the selected option is "Political Party"
 // if (options && options === 'Political Party') {
      try {
          const announcements = await addannounce.find({
              selectedOptions: { $in: ['Political Party'] }, // Filter for Political Party
          });
          console.log(`${announcements}`);
          const response = announcements.map(announcement => ({
            pdate:announcement.pdate,
            id: announcement.pid,
            announcement: announcement.announcement,
            images: announcement.images.map(img => ({
              data: img.data.toString('base64'),
              contentType: img.contentType,
            })),
          }));
          res.status(200).json(response);
      } catch (error) {
          console.error(error);
          res.status(500).json({ message: 'Failed to fetch announcements.' });
      }
 
});





app.get('/caannouncements', async (req, res) => {
  //const { options } = req.query; // Access query parameter
//console.log(`${options}`)
  // Check if the selected option is "Political Party"
 // if (options && options === 'Political Party') {
      try {
          const announcements = await addannounce.find({
              selectedOptions: { $in: ['Constituency'] }, // Filter for Political Party
          });
          console.log(`${announcements}`);
          const response = announcements.map(announcement => ({
            pdate:announcement.pdate,
            id: announcement.pid,
            announcement: announcement.announcement,
            images: announcement.images.map(img => ({
              data: img.data.toString('base64'),
              contentType: img.contentType,
            })),
          }));
          res.status(200).json(response);
      } catch (error) {
          console.error(error);
          res.status(500).json({ message: 'Failed to fetch announcements.' });
      }
 
});





app.get('/paannouncements', async (req, res) => {
  //const { options } = req.query; // Access query parameter
//console.log(`${options}`)
  // Check if the selected option is "Political Party"
 // if (options && options === 'Political Party') {
      try {
          const announcements = await addannounce.find({
              selectedOptions: { $in: ['Polling Station'] }, // Filter for Political Party
          });
          console.log(`${announcements}`);
          const response = announcements.map(announcement => ({
            pdate:announcement.pdate,
            id: announcement.pid,
            announcement: announcement.announcement,
            images: announcement.images.map(img => ({
              data: img.data.toString('base64'),
              contentType: img.contentType,
            })),
          }));
          res.status(200).json(response);
      } catch (error) {
          console.error(error);
          res.status(500).json({ message: 'Failed to fetch announcements.' });
      }
 
});


app.get('/vannouncements', async (req, res) => {
  //const { options } = req.query; // Access query parameter
//console.log(`${options}`)
  // Check if the selected option is "Political Party"
 // if (options && options === 'Political Party') {
      try {
          const announcements = await addannounce.find({
              selectedOptions: { $in: ['Voter'] }, // Filter for Political Party
          });
          console.log(`${announcements}`);
          const response = announcements.map(announcement => ({
            pdate:announcement.pdate,
            id: announcement.pid,
            announcement: announcement.announcement,
            images: announcement.images.map(img => ({
              data: img.data.toString('base64'),
              contentType: img.contentType,
            })),
          }));
          res.status(200).json(response);
      } catch (error) {
          console.error(error);
          res.status(500).json({ message: 'Failed to fetch announcements.' });
      }
 
});





// Start the server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});