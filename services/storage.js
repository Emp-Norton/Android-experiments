import AsyncStorage from '@react-native-async-storage/async-storage';

const Storage = {
  getNotes: async () => {
    const notes = await AsyncStorage.getItem('notes');
    return notes ? JSON.parse(notes) : [];
  },
  addNote: async note => {
    const notes = await Storage.getNotes();
    notes.push(note);
    await AsyncStorage.setItem('notes', JSON.stringify(notes));
  },
  deleteNote: async id => {
    const notes = await Storage.getNotes();
    const newNotes = notes.filter(note => note.id !== id);
    await AsyncStorage.setItem('notes', JSON.stringify(newNotes));
  },
};

export default Storage;