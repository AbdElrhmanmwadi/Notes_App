# Note App with SQLite and BLoC

This is a simple note-taking and task management app built using Flutter, utilizing SQLite for data storage and the BLoC architecture for state management. The app consists of two main pages: one for managing notes and another for managing tasks. Users can customize the appearance of notes, including changing colors, font sizes, and layouts. The app supports various operations such as creating, updating, deleting, and reading notes and tasks.

## Features

Notes Page:

Display a list of all saved notes.
Each note entry shows the title, content preview, color, and font size.
Users can tap on a note to view its full content.
Notes can be sorted based on creation date, last update, or custom order.
Users can customize the appearance of individual notes, including background color, font size, and layout.
Users can create new notes, update existing notes, and delete notes.

Tasks Page:

Display a list of tasks with titles and completion status.
Users can mark tasks as completed or pending.
Tasks can be sorted based on completion status, due date, or custom order.
Users can create new tasks, update existing tasks, and delete tasks.

Customization:

Users can change the color of each note to visually organize them.
Users can adjust the font size of notes for better readability.
Users can choose from different layout options to display notes in a way that suits their preference.

BLoC Architecture:

The app follows the BLoC (Business Logic Component) architecture for efficient state management.
BLoCs manage the data flow and business logic independently from the UI components.
This separation enhances maintainability and testability of the app.
