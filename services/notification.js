import PushNotification from 'react-native-push-notification';

const Notification = {
  scheduleNotification: note => {
    PushNotification.localNotificationSchedule({
      title: 'Reminder',
      message: note.text,
      date: new Date(note.reminderDate),
    });
  },
};

export default Notification;