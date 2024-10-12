
import 'package:e_learning_app/model/programming_course.dart';

List<ProgrammingCourse> programmingCourses = [
  ProgrammingCourse(
    id: 1,
    name: 'Introduction to Dart Programming',
    duration: 120,
    description:
        'Learn the basics of Dart programming language used for Flutter development.',
    link:
        'https://youtube.com/playlist?list=PL93xoMrxRJIsYc9L0XBSaiiuq01JTMQ_o&si=AdrGA4jQQviMa4J5',
    price: 100,
    outlines: [
      'Introduction to Dart',
      'Variables and Data Types',
      'Control Flow Statements',
      'Functions and Methods',
      'Object-Oriented Programming in Dart',
    ],
    categories: [
      Category.mobiledevelopment,
      Category.webdevelopment,
      Category.all
    ],
  ),
  ProgrammingCourse(
    id: 2,
    name: 'Mobile App Development with Flutter',
    duration: 180,
    description:
        'Comprehensive course on how to build mobile applications using Flutter.',
    link:
        'https://youtube.com/playlist?list=PL93xoMrxRJIvtIXjAiX15wcyNv-LOWZa9&si=Z-nm8aFt1DSNP30l',
    price: 130,
    outlines: [
      'Introduction to Flutter',
      'Building UI with Widgets',
      'State Management',
      'Navigation and Routing',
      'Using APIs in Flutter',
    ],
    categories: [Category.mobiledevelopment, Category.all],
  ),
  ProgrammingCourse(
    id: 3,
    name: 'Java Programming Basics',
    duration: 150,
    description:
        'Introduction to Java programming and its various applications.',
    link:
        'https://youtube.com/playlist?list=PL1DUmTEdeA6K7rdxKiWJq6JIxTvHalY8f&si=b0iEygCUsrSATtig',
    price: 170,
    outlines: [
      'Introduction to Java',
      'Variables and Data Types',
      'Loops and Conditional Statements',
      'Object-Oriented Programming',
      'Exception Handling',
    ],
    categories: [
      Category.mobiledevelopment,
      Category.webdevelopment,
      Category.all
    ],
  ),
  ProgrammingCourse(
    id: 4,
    name: 'Android Development with Java',
    duration: 210,
    description:
        'Learn how to develop Android apps using Java programming language.',
    link:
        'https://youtube.com/playlist?list=PL_c9BZzLwBRJLm0QETVj_XcN4jRsV4LkR&si=HBKBiXuXqqnnI4yk',
    price: 250,
    outlines: [
      'Setting up Android Studio',
      'Building User Interfaces',
      'Handling User Input',
      'Networking and APIs',
      'Publishing Apps to Play Store',
    ],
    categories: [Category.mobiledevelopment, Category.all],
  ),
  ProgrammingCourse(
    id: 5,
    name: 'Python Programming Fundamentals',
    duration: 140,
    description:
        'A comprehensive introduction to Python programming language and its use cases.',
    link:
        'https://youtube.com/playlist?list=PLoP3S2S1qTfCUdNazAZY1LFALcUr0Vbs9&si=YbZZO35VPcu9DvLv',
    price: 80,
    outlines: [
      'Introduction to Python',
      'Control Flow',
      'Functions and Modules',
      'File Handling',
      'Object-Oriented Programming',
    ],
    categories: [Category.datascience, Category.ai, Category.all],
  ),
  ProgrammingCourse(
    id: 6,
    name: 'Backend Development with Python',
    duration: 120, // Duration in hours
    description:
        'An in-depth course designed to teach you backend development using Python. Learn to build robust web applications and APIs using popular frameworks and tools in the Python ecosystem.',
    link:
        'https://youtube.com/playlist?list=PLynpHWDBs7h1e8dkxgO6jwUHaNb3UTGwQ&si=3JQr27-bLnzdRTJZ',
    price: 400,
    outlines: [
      'Introduction to Backend Development and Python',
      'Setting Up Your Python Development Environment',
      'Working with Web Frameworks: Flask and Django',
      'Building RESTful APIs with Flask',
      'Database Integration: SQL with SQLite and PostgreSQL',
      'User Authentication and Authorization',
      'Error Handling and Logging',
      'Deployment Strategies and Best Practices',
    ],
    categories: [Category.all, Category.webdevelopment],
  ),
  ProgrammingCourse(
    id: 7,
    name: 'React for Beginners',
    duration: 130,
    description: 'Get started with React to build modern web applications.',
    link:
        'https://youtube.com/playlist?list=PLYyqC4bNbCIdSZ-JayMLl4WO2Cr995vyS&si=z-SMmqB01cNO2inn',
    price: 260,
    outlines: [
      'Introduction to React',
      'JSX and Components',
      'State and Props',
      'React Hooks',
      'Handling Events',
    ],
    categories: [Category.webdevelopment, Category.all],
  ),
  ProgrammingCourse(
    id: 8,
    name: 'Backend Development with Node.js',
    duration: 190,
    description:
        'Learn how to create server-side applications using Node.js and Express.js.',
    link:
        'https://youtube.com/playlist?list=PLpSOK_rijUlnoSM5bIlfmuKa3H7XaqAyF&si=knvz_c7U4ZQRhMJv',
    price: 187,
    outlines: [
      'Introduction to Node.js',
      'Building APIs with Express.js',
      'Working with Databases',
      'Authentication and Authorization',
      'Deploying Node.js Apps',
    ],
    categories: [Category.webdevelopment, Category.all],
  ),
  ProgrammingCourse(
    id: 9,
    name: 'API Development with Python and Flask',
    duration: 100, // Duration in hours
    description:
        'Learn how to design and build RESTful APIs using Python and Flask. This course will cover everything from the basics of Flask to more advanced topics like authentication, database management, and deployment strategies.',
    link:
        'https://youtube.com/playlist?list=PLPBnj6azlABaelnh4bcmJ7VZNB_UIvhRt&si=-EMRWa-hUf3o2PYy',
    price: 100,
    outlines: [
      'Introduction to API Concepts and RESTful Architecture',
      'Setting Up Flask and Creating Your First API',
      'Routing and Request Handling',
      'Database Integration with SQL and Flask-SQLAlchemy',
      'Implementing User Authentication with JWT',
      'Testing APIs with Postman',
      'Error Handling and Logging Best Practices',
      'Deploying Flask Applications with Docker',
    ],
    categories: [
      Category.mobiledevelopment,
      Category.all,
    ],
  ),
  ProgrammingCourse(
    id: 10,
    name: 'Introduction to Machine Learning with Python',
    duration: 200,
    description:
        'Learn the fundamentals of machine learning using Python and popular libraries like TensorFlow.',
    link:
        'https://youtube.com/playlist?list=PLtsZ69x5q-X9j44MdSX-NGuOhGXOY0aqH&si=D0nJptQuvwsfK7Tb',
    price: 199,
    outlines: [
      'Introduction to Machine Learning',
      'Supervised vs Unsupervised Learning',
      'Building Models with Scikit-learn',
      'Neural Networks with TensorFlow',
      'Evaluating and Tuning Models',
    ],
    categories: [Category.ai, Category.datascience, Category.all],
  ),
  ProgrammingCourse(
    id: 11,
    name: 'Artificial Intelligence Basics',
    duration: 180,
    description:
        'Understand the basics of AI, its applications, and key concepts like neural networks and deep learning.',
    link:
        'https://youtube.com/playlist?list=PLuNK096Q36cY97nBykqIRGGM2UiFtq4OQ&si=zYeIOIkXJJEsS9e1',
    price: 200,
    outlines: [
      'Introduction to Artificial Intelligence',
      'Machine Learning Concepts',
      'Neural Networks and Deep Learning',
      'AI Applications in Real-World',
      'Ethics in AI',
    ],
    categories: [Category.ai, Category.all],
  ),
  ProgrammingCourse(
    id: 12,
    name: 'Data Science with Python',
    duration: 220,
    description:
        'Learn data science concepts, including data analysis, visualization, and machine learning with Python.',
    link:
        'https://youtube.com/playlist?list=PLMYF6NkLrdN9oTARJ9BE1EChtcsPjPEZQ&si=o1V-hXKjqiq6gnGG',
    price: 210,
    outlines: [
      'Introduction to Data Science',
      'Data Analysis with Pandas',
      'Data Visualization with Matplotlib',
      'Machine Learning with Scikit-learn',
      'Deploying Data Science Projects',
    ],
    categories: [Category.datascience, Category.all],
  ),
  ProgrammingCourse(
    id: 13,
    name: 'Web Development with HTML, CSS, and JavaScript',
    duration: 110,
    description:
        'Learn to build responsive websites using HTML, CSS, and JavaScript.',
    link:
        'https://youtube.com/playlist?list=PLknwEmKsW8Otkp3ax3DWDWQufKy4RirWO&si=U4rPnuvE7YEhnyCy',
    price: 360,
    outlines: [
      'Introduction to Web Development',
      'HTML Basics',
      'Styling with CSS',
      'JavaScript Fundamentals',
      'Responsive Design',
    ],
    categories: [Category.webdevelopment, Category.all],
  ),
  ProgrammingCourse(
    id: 14,
    name: 'SQL for Beginners',
    duration: 100,
    description: 'Understand how to manage and query databases using SQL.',
    link:
        'https://youtube.com/playlist?list=PLxbVBWjVdAEj8TmOUKPG0avUmLqSoQOpf&si=wXVAdv_1jNtHyClT',
    price: 138,
    outlines: [
      'Introduction to Databases',
      'Writing SQL Queries',
      'Joins and Subqueries',
      'Database Management',
      'SQL Best Practices',
    ],
    categories: [Category.datascience, Category.all],
  ),
  ProgrammingCourse(
    id: 15,
    name: 'DevOps Foundations',
    duration: 170,
    description:
        'Learn the basics of DevOps practices and tools like Docker, Kubernetes, and CI/CD pipelines.',
    link:
        'https://youtube.com/playlist?list=PLQ5OGqigB8Vn4xo-RMeS1ra8WzxFqyCKN&si=bklbNvo1A9Wlz-XE',
    price: 300,
    outlines: [
      'Introduction to DevOps',
      'Continuous Integration and Deployment',
      'Version Control with Git',
      'Containerization with Docker',
      'Kubernetes for Orchestration',
    ],
    categories: [Category.devops, Category.all],
  ),
];
