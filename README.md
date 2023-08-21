# Note App with SQLite and GetX State Management

This is a simple note-taking and task management app built using Flutter, with data storage handled by SQLite and state management powered by the GetX library. The app comprises two main pages: one for managing notes and another for managing tasks. Users have the ability to personalize the appearance of notes, including adjusting colors, font sizes, and layouts. The app supports various operations, such as creating, updating, deleting, and reading notes and tasks.

## Features
Notes Page:

Display a comprehensive list of all saved notes.
Each note entry exhibits the title, a preview of the content, color, and font size.
Users can tap on a note to view its complete content.
Notes can be sorted based on creation date, last update, or custom order.
Users can personalize the appearance of individual notes, including background color, font size, and layout.
Users can create new notes, update existing ones, and delete notes.

Tasks Page:

Showcase a list of tasks, indicating titles and completion status.
Users can toggle task completion status between completed and pending.
Tasks can be sorted based on completion status, due date, or custom order.
Users can create new tasks, update existing tasks, and delete tasks.

Customization:

Users can alter the color of each note to aid in organization.
Users can modify the font size of notes for improved readability.
Users can select from a range of layout options to display notes according to their preference.

GetX State Management:

The app employs the GetX library for efficient and reactive state management.
GetX provides observables, reactive programming, and dependency injection.
This approach streamlines the app's state management and UI updates.
