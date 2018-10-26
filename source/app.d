/*
 * This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not
 * distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */
import std.stdio;

import std.experimental.logger;

import gctest;

int main(string[] args) {

    trace("Creating app");
    auto gctestApp = new GCTest();
    int result;
    try {
        trace("Running application...");
        result = gctestApp.run(args);
        trace("App completed...");
    }
    catch (Exception e) {
        error("Unexpected exception occurred");
        error("Error: " ~ e.msg);
    }
    return result;
}