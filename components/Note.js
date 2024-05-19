import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import Icon from 'react-native-vector-icons/MaterialIcons';

const Note = ({ note, onDelete }) => {
  return (
    <View>
      <Text>{note.text}</Text>
      <TouchableOpacity onPress={() => onDelete(note.id)}>
        <Icon name="delete" size={30} color="#900" />
      </TouchableOpacity>
    </View>
  );
};

export default Note;