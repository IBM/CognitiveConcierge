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
*/

import Foundation


class OccasionGenerator {

    var occasionsKeywords: [String: [String]]
    var birthday: [String]
    var date: [String]
    var anniversary: [String]
    var family: [String]

    init() {

        occasionsKeywords = [String: [String]]()

        birthday = [String]()
        birthday.append("group")
        birthday.append("fun")
        birthday.append("birthday")
        birthday.append("casual")

        date = [String]()
        date.append("romantic")
        date.append("date")
        date.append("date night")
        date.append("fun")
        date.append("love")
        date.append("romance")
        date.append("intimate")
        date.append("romantic")
        date.append("different")
        date.append("adventurous")
        date.append("classy")


        anniversary = [String]()
        anniversary.append("romantic")
        anniversary.append("excellent")
        anniversary.append("date")
        anniversary.append("date night")
        anniversary.append("intimate")
        anniversary.append("anniversary")
        anniversary.append("romance")
        anniversary.append("perfect")
        anniversary.append("prix-fixe")
        anniversary.append("celebratory")
        anniversary.append("champagne")
        anniversary.append("blessed")
        anniversary.append("classy")
        anniversary.append("hooray")
        anniversary.append("expensive")
        anniversary.append("joy")
        anniversary.append("sparkling")
        anniversary.append("joyful")
        anniversary.append("upscale")
        anniversary.append("wine")
        anniversary.append("reservations")
        anniversary.append("husband")
        anniversary.append("wife")
        anniversary.append("classy")
        anniversary.append("weekend")



        family = [String]()
        family.append("group")
        family.append("fun")
        family.append("casual")
        family.append("kid")
        family.append("family")
        family.append("child")
        family.append("friendly")
        family.append("kids")
        family.append("no alcohol")
        family.append("non-alchoholic")



        occasionsKeywords["birthday"] = birthday
        occasionsKeywords["date"] = date
        occasionsKeywords["anniversary"] = anniversary
        occasionsKeywords["family"] = family
    }

    func getOccasionKeywords(_ theOccasion: String) -> [String] {
        return occasionsKeywords[theOccasion] ?? []
    }

}
