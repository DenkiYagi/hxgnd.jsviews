package hxgnd.js.jsviews;

import js.html.Element;
import hxgnd.js.JqHtml;
import haxe.ds.Option;

@:native("$")
extern class JsViews {
    static var templates(default, never): JsObject<Template>;

    //static var render(default, never): JsObject<{} -> String>;

    static var views: {
        @:overload(function (namedConverters: JsObject<Dynamic -> Dynamic>, ?parentTemplate: String): Void{})
        function converters(name: String, fn: Dynamic -> Dynamic): Dynamic;

        @:overload(function (name: String, tagOptions: TagOptions): Void{})
        @:overload(function (namedTags: {}, ?parentTemplate: String): Void{})
        function tags(name: String, fn: Dynamic -> String): Void;

        @:overload(function (namedHelpers: {}, ?parentTemplate: String): Void{})
        function helpers(name: String, fn: Dynamic -> Dynamic): Void;
    };

    @:overload(function (markupOrSelector: String): Template{})
    @:overload(function (templateOptions: TemplateOptions): Template{})
    @:overload(function (name: String, templateOptions: TemplateOptions): Template{})
    @:overload(function (namedTemplates: {}, ?parentTemplate: String): Void{})
    static inline function template(name: String, markupOrSelector: String): Template {
        return untyped __js__("$.templates.apply")(null, (markupOrSelector == null) ? [name] : [name, markupOrSelector]);
    }

    static inline function getTemplate(name: String): Option<Template> {
        var t = untyped __js__("$.templates")[name];
        return (t != null) ? Some(t) : None;
    }

    @:overload(function (flag: Bool, to: Element, from: {}, ?context: {}): Void{})
    @:overload(function (flag: Bool, to: JqHtml, from: {}, ?context: {}): Void{})
    @:overload(function (template: Template, to: String, from: {}, ?context: {}): Void{})
    @:overload(function (template: Template, to: Element, from: {}, ?context: {}): Void{})
    @:overload(function (template: Template, to: JqHtml, from: {}, ?context: {}): Void{})
    static function link(flag: Bool, to: String, from: {}, ?context: {}): Void;

    @:overload(function (flag: Bool, to: Element): Void{})
    @:overload(function (flag: Bool, to: JqHtml): Void{})
    @:overload(function (template: Template, to: String): Void{})
    @:overload(function (template: Template, to: Element): Void{})
    @:overload(function (template: Template, to: JqHtml): Void{})
    @:overload(function (): Void{})
    static function unlink(flag: Bool, to: String) : Void;

    @:overload(function (object: JsObject<Dynamic>): Observable{})
    @:overload(function (object: {}): Observable{})
    static function observable(array: Array<Dynamic>) : Observable;

    @:overload(function (object: {}, ?path: String, myHandler: ObservableEvent -> ObservableEventArgs -> Void): Void{})
    static function observe(array: Array<Dynamic>, myHandler: ObservableEvent -> ObservableEventArgs -> Void) : Void;

    @:overload(function (array: Array<Dynamic>): {}{})
    @:overload(function (object: {}): {}{})
    @:overload(function (object: {}, ?path: String, myHandler: ObservableEvent -> ObservableEventArgs -> Void): Void{})
    static function unobserve(array: Array<Dynamic>, myHandler: ObservableEvent -> ObservableEventArgs -> Void): Void;
}

typedef TagOptions = {
    ?render: Dynamic -> String,
    ?template: String,
    ?dataBoundOnly: Bool,
    ?autoBind: Bool, // On the opening tag with no args, if autoBind is true, bind the the current data context
    ?flow: Bool,
    ?init: TagCtx -> Dynamic -> Void,
    ?onBeforeLink: Void -> Bool,
    ?onAfterLink: TagCtx -> LinkCtx -> Void,
    ?onUpdate: ObservableEvent -> ObservableEventArgs -> TagCtx -> Bool,
    ?onBeforeChange: ObservableEvent -> ObservableEventArgs -> Bool,
    ?onDispose: Void -> Void
}

typedef TemplateOptions = {
    markup: String,
    ?converters: {},
    ?helpers: {},
    ?tags: {}
}

extern class Template {
    var htmlTag(default, never): String;
    var markup(default, never): String;

    function render(?data: {}, ?helpers: JsObject<Dynamic -> Dynamic>, ?noIteration: Bool): String;

    @:overload(function (to: Element, from: JsObject<Dynamic>, ?context: {}): Void{})
    @:overload(function (to: JqHtml, from: JsObject<Dynamic>, ?context: {}): Void{})
    function link(to: String, from: JsObject<Dynamic>, ?context: {}): Void;

    @:overload(function (to: Element): Void{})
    @:overload(function (to: JqHtml): Void{})
    function unlink(to: String): Void;
}

extern class TagCtx {
    var args(default, never): Array<Dynamic>;
    var content(default, never): TmplObject;
    var ctx(default, never): Dynamic;
    var index(default, never): Int;
    var markup(default, never): String;
    var params(default, never): String; // TODO 要確認:commit55で Array<String> ?
    var props(default, never): JsObject<Dynamic>;
    function render(?data: {}, ?helpers: JsObject<Dynamic -> Dynamic>, ?noIteration: Bool): String;
    var tag(default, never): TagDef;
    var tmpl(default, default): TmplObject;
    var views(default, never): Dynamic;
}

abstract TagDef(Dynamic) {
    public var _(get, never): Dynamic<Dynamic>;
    public var ctx(get, never): Dynamic;
    public var linkCtx(get, never): LinkCtx;
    public var linkedElem(get, set): Null<Dynamic>;
    public var parentElem(get, never): Element;
    public var tagCtx(get, never): TagCtx;
    public var tagName(get, never): String;
    public var template(get, set): Null<Template>;

    public inline function contents(selector: String): JqHtml {
        return this.contents(selector);
    }

    public inline function refresh(?sourceValue: Dynamic): Void {
        this.refresh(sourceValue);
    }

    public inline function update(value: Dynamic): Void {
        this.update(value);
    }

    @:arrayAccess inline function get(key: String): Null<Dynamic> {
        return untyped this[key];
    }

    @:arrayAccess inline function set(key:String, value: Dynamic): Dynamic {
        return untyped this[key] = value;
    }

    inline function get__(): Dynamic<Dynamic> return this._;
    inline function get_ctx(): Dynamic return this.ctx;
    inline function get_linkCtx(): LinkCtx return this.linkCtx;
    inline function get_linkedElem(): Null<Dynamic> return this.linkedElem;
    inline function set_linkedElem(x): Null<Dynamic> return this.linkedElem = x;
    inline function get_parentElem(): Element return this.parentElem;
    inline function get_tagCtx(): TagCtx return this.tagCtx;
    inline function get_tagName(): String return this.tagName;
    inline function get_template(): Null<Template> return this.template;
    inline function set_template(x): Null<Template> return this.template = x;
}

typedef TmplObject = {
    var htmlTag(default, never): String;
    var markup(default, never): String;
    function render(?data: {}, ?helpers: JsObject<Dynamic -> Dynamic>, ?noIteration: Bool): String;
}

typedef LinkCtx = {
    var attr(default, never): String;
    var ctx(default, never): Dynamic;
    var data(default, never): Dynamic;
    var elem(default, never): Element;
    var tag(default, never): TagDef;
    var view(default, never): Dynamic;
}

typedef ConverterCtx = {
    var args(default, never): Array<Dynamic>;
    var params(default, never): String;
    var props(default, never): JsObject<Dynamic>;
    var views(default, never): Dynamic;
}

typedef Observable = {
    function observeAll(myHandler: ObservableEvent -> ObservableEventArgs -> Void): Void;
    function unobserveAll(myHandler: ObservableEvent -> ObservableEventArgs -> Void): Void;
    function data(): Dynamic;

    // for object
    @:overload(function (newValues: JsObject<Dynamic>): Template{})
    function setProperty(path: String, value: Dynamic): Observable;

    // for array
    @:overload(function (newItem: Dynamic): Template{})
    function insert(index: Int, newItem: Dynamic): Observable;

    function remove(index: Int, ?numToRemove: Int): Observable;

    function move(oldIndex: Int, newIndex: Int, ?numToMove: Int): Observable;

    function refresh(newItems: Array<Dynamic>): Observable;
}

typedef ObservableEvent = {
    var target(default, never): Dynamic; // Object or Array<Dynamic>
    var data(default, never): Dynamic<Dynamic>; // JsViews metadata
}

typedef ObservableEventArgs = {
    var change(default, never): ObservableEventType;

    var path(default, never): Null<String>;      // object / set
    var value(default, never): Null<Dynamic>;    // object / set
    var oldValue(default, never): Null<Dynamic>; // object / set
    var index(default, never): Null<Int>;             // array / insert, remove, move
    var items(default, never): Null<Array<Dynamic>>;  // array / insert, move
    var numToRemove(default, never): Null<Int>;       // array / remove
    var oldIndex(default, never): Null<Int>;          // array / move
    var oldItem(default, never): Null<Dynamic>;       // array / refresh
}

@:enum abstract ObservableEventType(String) {
    var Set = "set";
    var Insert = "insert";
    var Remove = "remove";
    var Move = "move";
    var Refresh = "refresh";
}


class JsViewsTools {
    public static inline function toEnum(ea: ObservableEventArgs): EnumedObservableEventArgs {
        return switch (ea.change) {
            case Set:
                Set(ea.path, ea.value, ea.oldValue);
            case Insert:
                Insert(ea.index, ea.items);
            case Remove:
                Remove(ea.index, ea.numToRemove);
            case Move:
                Move(ea.oldIndex, ea.index, ea.items);
            case Refresh:
                Refresh(ea.oldItem);
        }
    }

    public static inline function args(): Array<Dynamic> {
        return untyped __js__("Array.prototype.slice.call(arguments)");
    }

    public static inline function tagDef(): TagDef {
        return untyped __js__("this");
    }
}

enum EnumedObservableEventArgs {
    Set(path: String, value: Dynamic, oldValue: Dynamic);
    Insert(index: Int, items: Array<Dynamic>);
    Remove(index: Int, numToRemove: Int);
    Move(oldIndex: Int, index: Int, items: Array<Dynamic>);
    Refresh(oldItem: Dynamic);
}

abstract JsObject<A>(Dynamic<A>) from Dynamic<A> to Dynamic<A> {
    inline function new(a: Dynamic<A>)
        this = a;

    @:from static public inline function fromObject(obj: {}) {
        return new JsObject(cast obj);
    }

    @:to inline function toObject<T: {}>(): T {
        return cast this;
    }

    @:arrayAccess inline function get(key: String): Null<Dynamic> {
        return untyped this[key];
    }

    @:arrayAccess inline function set(key:String, value: Dynamic): Dynamic {
        return untyped this[key] = value;
    }
}
