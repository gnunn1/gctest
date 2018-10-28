module gctest;

import core.memory;
import std.conv;
import std.experimental.logger;

import gio.Application: GApplication = Application;

import gtk.Application;
import gtk.ApplicationWindow;
import gtk.Box;
import gtk.Button;
import gtk.HeaderBar;
import gtk.Label;
import gtk.ListBox;
import gtk.ListBoxRow;
import gtk.Main;
import gtk.ScrolledWindow;

class GCTest : Application {

    const string APPLICATION_ID = "com.gexperts.gctest";

    private:
        void onAppActivate(GApplication app) {
            trace("Activate App Signal");
            GCTestWindow window = new GCTestWindow(this);
            window.showAll();
        }


    public:
        this() {
            super(APPLICATION_ID, ApplicationFlags.FLAGS_NONE);

            this.addOnActivate(&onAppActivate);
    //        this.addOnStartup(&onAppStartup);
        }
}


class GCTestWindow: ApplicationWindow {

    ScrolledWindow sw;
    ListBox lb;
    uint counter = 0;

    private:
        void createUI() {
            //Header bar
            HeaderBar hb = new HeaderBar();
            hb.setTitle("GCTest");
            hb.setShowCloseButton(true);

            Button btnGC = new Button("GC");
            btnGC.addOnClicked(delegate(Button) {
                core.memory.GC.collect();
                trace("GC Initiated");
            });

            Button btnRecreate = new Button("Recreate Rows");
            btnRecreate.addOnClicked(delegate(Button) {
                recreateRows();
            });

            hb.packEnd(btnRecreate);
            hb.packEnd(btnGC);

            this.setTitlebar(hb);

            //listbox
            lb = new ListBox();

            sw = new ScrolledWindow(lb);
            sw.setPolicy(PolicyType.NEVER, PolicyType.AUTOMATIC);
            sw.setShadowType(ShadowType.IN);

            add(sw);
        }

    private:
        void recreateRows() {
            trace("Recreating rows");
            lb.removeAll();
            for (int i = 0; i <= 10; i++) {
                GCListBoxRow row = new GCListBoxRow(this, counter++);
                lb.add(row);
            }
            lb.showAll();
        }

    public:
        this(Application application) {
            super(application);
            createUI();
            recreateRows();
        }
}

class GCListBoxRow: ListBoxRow {
    private:
      Label lblText;
      Button btnTest;
      GCTestWindow window;

    public:
        this(GCTestWindow window, uint counter) {
            super();
            this.window = window;
            trace("Creating row");

            Box box = new Box(Orientation.HORIZONTAL,6);
            lblText = new Label("This is row " ~ to!string(counter));
            box.add(lblText);

            btnTest = new Button("Test");

            // Comment out event handler to see GC working
            btnTest.addOnClicked(delegate(Button) {
                trace("I've been clicked");
                lblText.setText("Clicked!");
            });
            box.add(btnTest);

            add(box);
        }

        ~this() {
            import std.stdio: writeln;
            writeln("******** ListBoxRow Destructor");
        }
}
