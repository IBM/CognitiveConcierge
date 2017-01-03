/**
 * Copyright IBM Corporation 2016
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import JSQMessagesViewController

// JSQMessages User Enum to make it easier to work with.
public enum User: String {
    case Hoffman    = "053496-4509-288"
    case Watson     = "707-8956784-57"
}

// JSQMessages Helper Function to get usernames for a secific User.
public func getName(user: User) -> String{
    switch user {
    case .Hoffman:
        return "Lara Hoffman"
    case .Watson:
        return "Thomas Watson"
    }
}

// JSQMessages Create an avatar with Image
private let avatarWatson = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named:"watson_avatar"), diameter: 37)!
private let avatarHoffman = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named:"avatar_small"), diameter: 37)!

// JSQMessages Helper Method for getting an avatar for a specific User.
public func getAvatar(id: String) -> JSQMessagesAvatarImage{
    let user = User(rawValue: id)!
    switch user {
    case .Hoffman:
        return avatarHoffman
    case .Watson:
        return avatarWatson
    }
}
