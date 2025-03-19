// import 'package:flutter/material.dart';

// class ForumImages extends StatelessWidget {
//   const ForumImages({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Community Forum"),
//         backgroundColor: Colors.blueAccent,
//         centerTitle: true,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blueAccent.shade100, Colors.blueAccent.shade400],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: GridView.count(
//             crossAxisCount: 2,
//             crossAxisSpacing: 16,
//             mainAxisSpacing: 16,
//             children: [
//               _buildForumSection(
//                 context,
//                 title: "Discussion Boards",
//                 subtitle: "Join discussions on various topics",
//                 icon: Icons.forum,
//                 color: const Color.fromARGB(255, 13, 96, 163),
//               ),
//               _buildForumSection(
//                 context,
//                 title: "Share Experience",
//                 subtitle: "Tell your experiences",
//                 icon: Icons.share,
//                 color: const Color.fromARGB(255, 85, 158, 88),
//               ),
//               _buildForumSection(
//                 context,
//                 title: "Events",
//                 subtitle: "Discover upcoming events",
//                 icon: Icons.event,
//                 color: Colors.orange,
//               ),
//               _buildForumSection(
//                 context,
//                 title: "Resource Library",
//                 subtitle: "Access guides, materials, and documents",
//                 icon: Icons.library_books,
//                 color: const Color.fromARGB(255, 129, 34, 146),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildForumSection(
//     BuildContext context, {
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required Color color,
//   }) {
//     return GestureDetector(
//       onTap: () {
//         // Handle navigation to respective pages
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Navigating to $title")),
//         );
//       },
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//         color: color.withOpacity(0.2),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 50, color: color),
//               const SizedBox(height: 10),
//               Text(
//                 title,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 subtitle,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 14, color: Colors.black54),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ForumImages extends StatelessWidget {
  const ForumImages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Community Forum"),
        backgroundColor: const Color.fromARGB(255, 137, 178, 250),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildForumSection(
              context,
              title: "Discussion Boards",
              subtitle: "Join discussions on various topics",
              icon: Icons.forum,
              color: Colors.blue,
              page: const DiscussionBoardPage(),
            ),
            _buildForumSection(
              context,
              title: "Share Experience",
              subtitle: "Tell your experiences",
              icon: Icons.share,
              color: Colors.green,
              page: const ShareExperiencePage(),
            ),
            _buildForumSection(
              context,
              title: "Events",
              subtitle: "Discover upcoming events",
              icon: Icons.event,
              color: Colors.orange,
              page: const EventsPage(),
            ),
            _buildForumSection(
              context,
              title: "Resource Library",
              subtitle: "Access guides, materials, and documents",
              icon: Icons.library_books,
              color: Colors.purple,
              page: const ResourceLibraryPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForumSection(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget page,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: color.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 50, color: color),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DiscussionBoardPage extends StatelessWidget {
  const DiscussionBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> discussions = [
      {
        "title": "Best Learning Methods",
        "author": "Alice",
        "content": "What’s the best way to improve learning efficiency?"
      },
      {
        "title": "Parenting Tips",
        "author": "John",
        "content": "How do you handle challenging behaviors?"
      },
      {
        "title": "Autism and School",
        "author": "Sarah",
        "content": "What are the best school programs for children with autism?"
      },
      {
        "title": "Diet and Nutrition",
        "author": "David",
        "content":
            "What are the best dietary practices for children with autism?"
      },
      {
        "title": "Therapy Suggestions",
        "author": "Emma",
        "content": "What therapies have been most effective for your child?"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Discussion Board",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade100, Colors.teal.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: discussions.length,
            itemBuilder: (context, index) {
              String userInitial =
                  discussions[index]['author']![0].toUpperCase();
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal.withOpacity(0.3),
                    child: Text(
                      userInitial,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  title: Text(
                    discussions[index]['title']!,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  subtitle: Text(
                    "${discussions[index]['content']}\n— ${discussions[index]['author']}",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  trailing:
                      const Icon(Icons.arrow_forward_ios, color: Colors.teal),
                  onTap: () {
                    // TODO: Navigate to discussion details page
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ShareExperiencePage extends StatelessWidget {
  const ShareExperiencePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> experiences = [
      {
        "name": "Sarah",
        "message":
            "My child just learned to communicate with simple sentences. So proud!"
      },
      {
        "name": "Mark",
        "message":
            "Our first therapy session was a success. The therapist was great!"
      },
      {
        "name": "Lisa",
        "message": "Finding the right school took time, but it was worth it!"
      },
      {
        "name": "David",
        "message":
            "We just joined a support group, and it has been life-changing!"
      },
      {
        "name": "Emma",
        "message": "Tried sensory-friendly toys, and they work wonders!"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Share Experience",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurpleAccent.shade100,
              Colors.deepPurple.shade800
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: experiences.length,
            itemBuilder: (context, index) {
              String userInitial = experiences[index]['name']![0].toUpperCase();
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3),
                    child: Text(
                      userInitial,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  title: Text(
                    experiences[index]['name']!,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  subtitle: Text(
                    experiences[index]['message']!,
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> events = [
      {
        "name": "Autism Awareness Webinar",
        "date": "March 25, 2025",
        "location": "Online",
        "icon": "🎙️"
      },
      {
        "name": "Parent Support Meetup",
        "date": "April 10, 2025",
        "location": "Community Center, NY",
        "icon": "🤝"
      },
      {
        "name": "Therapy Techniques Workshop",
        "date": "May 5, 2025",
        "location": "Wellness Hub, LA",
        "icon": "🧠"
      },
      {
        "name": "Autism-Friendly Playdate",
        "date": "June 15, 2025",
        "location": "Central Park, NY",
        "icon": "🎈"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Events",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.shade100, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(15),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    child: Text(
                      events[index]['icon']!,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  title: Text(
                    events[index]['name']!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "📅 ${events[index]['date']!}  |  📍 ${events[index]['location']!}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Will be available soon!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Join",
                        style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class ResourceLibraryPage extends StatelessWidget {
  const ResourceLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> resources = [
      // {
      //   "title": "Beginner's Guide to Autism",
      //   "link": "https://www.autismspeaks.org/sites/default/files/2018-08/Autism%20Speaks%20First%20Concern%20to%20Action.pdf",
      //   "icon": "📘"
      // },
      {
        "title": "Best Therapy Techniques",
        "link": "https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8413786/",
        "icon": "🧠"
      },
      {
        "title": "Support Groups for Parents",
        "link":
            "https://www.autismspeaks.org/family-services/community-connections/support-groups",
        "icon": "🤝"
      },
      {
        "title": "Speech & Communication Strategies",
        "link": "https://www.asha.org/public/speech/disorders/Autism/",
        "icon": "🗣️"
      },
      {
        "title": "Autism-Friendly Learning Apps",
        "link": "https://www.autismspeaks.org/autism-apps",
        "icon": "📱"
      }
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resource Library",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent.shade100, Colors.blue.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: resources.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: Text(resources[index]['icon']!,
                      style: const TextStyle(fontSize: 30)),
                  title: Text(
                    resources[index]['title']!,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      final Uri url = Uri.parse(resources[index]['link']!);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      } else {
                        throw 'Could not launch ${resources[index]['link']}';
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("View",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
