//
//  ElapsedTimeView.swift
//  mitri
//
//  Created by Tofunmi Ogungbaigbe on 21/12/2022.
//

import SwiftUI

extension Date {
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
}

struct ElapsedTimeView: View {
    let elapsedTimeMilliseconds: Int
    private static let formatter = RelativeDateTimeFormatter()
        .withDateTimeStyle(dateTimeStyle: .named)
    
    var elapsedTimDate: Date {
        return Date(milliseconds: elapsedTimeMilliseconds)
    }
    
    var body: some View {
        TimelineView(.animation(minimumInterval: 5)) { timeline in
            let formatted = ElapsedTimeView.formatter.localizedString(for: elapsedTimDate, relativeTo: timeline.date)
            Text("\(formatted)")
                .fontWeight(.ultraLight)
        }
    }
}

struct ElapsedTimeView_Previews: PreviewProvider {
    static var previews: some View {
        ElapsedTimeView(elapsedTimeMilliseconds: 1671065342710)
            .previewLayout(.sizeThatFits)
    }
}
