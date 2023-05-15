import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue[900]!,
                      Colors.blue[800]!,
                      Colors.blue[700]!,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 50.0,
                left: 20.0,
                child: Container(
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    gradient: RadialGradient(
                      colors: [
                        Colors.blue[900]!,
                        Colors.blue[800]!,
                        Colors.blue[700]!,
                      ],
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user_icon.png'),
                  ),
                ),
              ),
              Positioned(
                top: 50.0,
                right: 20.0,
                child: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
              Positioned(
                top: 190.0,
                left: 0.0,
                right: 0.0,
                child: Column(
                  children: [
                    Text(
                      'John Doe',
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Metaverse Designer',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: Colors.blue[700],
                  labelColor: Colors.blue[700],
                  unselectedLabelColor: Colors.grey[500],
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Experience'),
                    Tab(text: 'Education'),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: TabBarView(
                    children: [
                      _buildOverview(),
                      _buildExperience(),
                      _buildEducation(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bio',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'I am a Metaverse Designer with 5 years of experience creating immersive digital environments and experiences. My core skills include 3D modeling, animation, and game design.',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 16.0),
          Text(
            'Skills',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: [
              Chip(
                label: Text('3D Modeling'),
                backgroundColor: Colors.blue[700],
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              Chip(
                label: Text('Animation'),
                backgroundColor: Colors.blue[700],
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              Chip(
                label: Text('Game Design'),
                backgroundColor: Colors.blue[700],
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              Chip(
                label: Text('UI/UX Design'),
                backgroundColor: Colors.blue[700],
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExperience() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Experience',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 16.0),
          _buildExperienceItem(
            company: 'Metaverse Studio',
            jobTitle: 'Senior Metaverse Designer',
            dateRange: '2019 - Present',
            description:
                'Lead designer on multiple projects, including a virtual trade show booth for a Fortune 500 company.',
          ),
          SizedBox(height: 8.0),
          _buildExperienceItem(
            company: 'Virtual Worlds Inc.',
            jobTitle: 'Metaverse Designer',
            dateRange: '2016 - 2019',
            description:
                'Worked on several VR and AR projects, including a virtual art exhibit and a location-based AR game.',
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceItem({
    required String company,
    required String jobTitle,
    required String dateRange,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          company,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          jobTitle,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          dateRange,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildEducation() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 16.0),
          _buildEducationItem(
            institution: 'University of California, Los Angeles',
            degree: 'Bachelor of Fine Arts in Design Media Arts',
            dateRange: '2012 - 2016',
            honors: 'MagnaCum Laude',
          ),
        ],
      ),
    );
  }

  Widget _buildEducationItem({
    required String institution,
    required String degree,
    required String dateRange,
    String? honors,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          institution,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          degree,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 4.0),
        Text(
          dateRange,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[700],
          ),
        ),
        if (honors != null) ...[
          SizedBox(height: 4.0),
          Text(
            honors,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.grey[700],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSkills() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Skills',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 8.0),
          Wrap(
            spacing: 8.0,
            children: [
              Chip(
                label: Text('Unity'),
                backgroundColor: Colors.blue[700],
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              Chip(
                label: Text('Unreal Engine'),
                backgroundColor: Colors.blue[700],
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              Chip(
                label: Text('Maya'),
                backgroundColor: Colors.blue[700],
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              Chip(
                label: Text('Photoshop'),
                backgroundColor: Colors.blue[700],
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
