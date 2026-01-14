//
//  RemindersView.swift
//  FootballMatches
//
//  Created by Mumen Murad on 24.12.25.
//

import SwiftUI
import UserNotifications

struct RemindersView: View {
    @State private var reminders: [UNNotificationRequest] = []
    
    var body: some View {
        List {
            if reminders.isEmpty {
                Text("No reminders set yet.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(reminders, id: \.identifier) { request in
                    VStack(alignment: .leading) {
                        Text(request.content.title)
                            .font(.headline)
                        Text(request.content.body)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete(perform: deleteReminder)
            }
        }
        .navigationTitle("My Reminders")
        .onAppear(perform: loadReminders)
    }
    
    func loadReminders() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            DispatchQueue.main.async {
                self.reminders = requests
            }
        }
    }
    
    func deleteReminder(at offsets: IndexSet) {
        let identifiers = offsets.map { reminders[$0].identifier }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        reminders.remove(atOffsets: offsets)
    }
}
