const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const bcrypt = require('bcryptjs');
const multer = require('multer');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 5000;

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

const userSchema1 = new mongoose.Schema({
  name: String,
  email: { type: String, unique: true }, // Ensure email is unique
  password: String,
  img: {
    data: Buffer,
    contentType: String,
  },
});


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
});

const addannounce = mongoose.model('Announcement', announcementSchema);


const Users = mongoose.model('politicalparty', userSchema1);
// User Registration Endpoint
app.post('/register', async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ status: false, message: 'Please provide all fields' });
  }

  try {
    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ status: false, message: 'User already exists' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new user
    const newUser = new User({
      email,
      password: hashedPassword,
    });

    await newUser.save();
    return res.status(201).json({ status: true, message: 'User registered successfully' });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});

// Configure multer for image uploads
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// Political Party Registration Endpoint
app.post('/registerpoliticalparty', upload.single('image'), async (req, res) => {
  const { name, email, password } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({ status: false, message: 'Please provide all fields' });
  }

  try {
    // Check if user already exists
    const existingUser = await Users.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ status: false, message: 'User already exists' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create a new political party user
    const newUsers = new Users({
      name,
      email,
      password: hashedPassword,
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
  const { announcement, pid } = req.body;

  if (!announcement || !pid) {
    return res.status(400).json({ status: false, message: 'Please provide all fields' });
  }

  try {
    // Create a new announcement
    const newAnnouncement = new addannounce({
      announcement,
      pid,
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
  try {
    const parties = await Users.find(); // Fetch all political parties
    const partiesWithImages = parties.map(party => ({
      name: party.name,
      email: party.email,
      img: party.img ? {
        data: party.img.data.toString('base64'), // Convert Buffer to base64 string
        contentType: party.img.contentType,
      } : null,
    }));
    return res.status(200).json({ status: true, data: partiesWithImages });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});

// Fetch all political parties
app.get('/politicalparties', async (req, res) => {
  const start = Date.now();
  try {
    const parties = await Users.find();
    const elapsed = Date.now() - start;
    console.log(`Fetch time: ${elapsed}ms`);
    return res.status(200).json({ status: true, data: parties });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ status: false, message: 'Server error' });
  }
});






app.get('/countparties', async (req, res) => {
  const count = await Users.countDocuments();
  res.json({ count });
});







app.delete('/political_party/delete', async (req, res) => {
  const email = req.query.email;
  console.log(`Attempting to delete party with email: ${email}`);

  if (!email) {
      return res.status(400).send('Email is required');
  }

  console.log(`Attempting to delete party with email: ${email}`);

  try {
      const result = await Users.deleteOne({ email });
      console.log(result); 
      // Log the result of the deletion

      if (result.deletedCount === 0) {
          return res.status(404).send('Party not found');
      }
      res.status(200).send('Party deleted successfully');
  } catch (error) {
      console.error(error);
      res.status(500).send('Internal Server Error');
  }
});




app.get('/announcements', async (req, res) => {
  try {
    const announcements = await addannounce.find(); // Fetch all announcements
    res.status(200).json(announcements);
  } catch (error) {
    console.error(error);
    res.status(500).json({ status: false, message: 'Server error' });
  }
});


// Start the server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});