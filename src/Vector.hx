package;

//Methods not prepended by "get" or "to" or "clone" are destructive. Call vector.clone() to get a copy to operate on if desired.
class Vector {
    public var x:Float;
    public var y:Float;
    public var z:Float;
    public var w:Float;

    public function new(x:Float=0,y:Float=0,z:Float=0,w:Float=0) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
    }

    /**
     * DESTRUCTIVE OPERATIONS
    **/
    
    public function multiply(other:Vector):Vector {
        this.x *= other.x;
        this.y *= other.y;
        this.z *= other.z;
        this.w *= other.w;
        return this;
    }
    public function add(other:Vector):Vector {
        this.x += other.x;
        this.y += other.y;
        this.z += other.z;
        this.w += other.w;
        return this;
    }
    public function subtract(other:Vector):Vector {
        this.x -= other.x;
        this.y -= other.y;
        this.z -= other.z;
        this.w -= other.w;
        return this;
    }
    public function divide(other:Vector):Vector {
        if(other.x != 0)
            this.x /= other.x;
        if(other.y != 0)
            this.y /= other.y;
        if(other.z != 0)
            this.z /= other.z;
        if(other.w != 0)
            this.w /= other.w;
        return this;
    }

    public function inverse():Vector {
        this.x = 1 / x;
        this.y = 1 / y;
        this.z = 1 / z;
        this.w = 1 / w;
        return this;
    }

    public function normalize():Vector {
        var mag = this.getMagnitude();
        if(mag == 0) {
            return this;
        }
        this.x /= mag;
        this.y /= mag;
        this.z /= mag;
        this.w /= mag;
        return this;
    }

    public function lerp(other:Vector,alpha:Float,?operation:VAEasings=null):Vector {
        this.x = VAUtils.lerp(this.x,other.x,alpha,operation);
        this.y = VAUtils.lerp(this.y,other.y,alpha,operation);
        this.z = VAUtils.lerp(this.z,other.z,alpha,operation);
        this.w = VAUtils.lerp(this.w,other.w,alpha,operation);
        return this;
    }

    public function cross(other:Vector):Vector {
        var buffer = this.clone();
        this.x = (buffer.y * other.z) - (buffer.z * other.y);
        this.y = (buffer.z * other.x) - (buffer.x * other.z);
        this.z = (buffer.x * other.y) - (buffer.y * other.x);
        return this;
    }

    public function dot(other:Vector):Vector {
        this.x *= other.x;
        this.y *= other.y;
        this.z *= other.z;
        return this;
    }

    //Only this vector changes; other vector is cloned before being normalized
    public function dotNormalize(other:Vector) {
        this.normalize();
        other.clone().normalize();
        return this.dot(other);
    }

    /**
     * NON-DESTRUCTIVE OPERATIONS
    **/

    //Should likely work. If dumb issues happen with vectors and this function is in use, then double check it and try using "getMagnitude() == 1" instead of "getMagnitudeFastSquare() == 1"
    public function isNormalized():Bool {
        return this.getMagnitudeFastSquare() == 1;
    }

    public function getMagnitude():Float {
        return Math.sqrt(this.x*this.x + this.y*this.y + this.z*this.z + this.w * this.w);
    }

    // Faster than getMagnitude, better for *comparing* distances without having to know specific values.
    public function getMagnitudeFastSquare():Float {
        return this.x*this.x + this.y*this.y + this.z*this.z + this.w * this.w;
    }

    public function getDistanceTo(other:Vector):Float {
        return Math.sqrt(Math.pow(this.x-other.x,2) + Math.pow(this.y-other.y,2) + Math.pow(this.z-other.z,2) + Math.pow(this.w-other.w,2));
    }

    public function getRadians2D(originX:Float=0, originY:Float=0):Float {
        return Math.atan2((this.y-originY), (this.x-originX));
    }
    public function getDegrees2D(originX:Float=0,originY:Float=0):Float {
        return getRadians2D(originX,originY) * 180 / Math.PI;
    }

    public function equals(other:Vector) {
        return this.x == other.x && this.y == other.y && this.z == other.z && this.w == other.w;
    }

    public function equalsFuzzy(other:Vector,within:Float=0) {
        return Math.abs(other.x - this.x) <= within && Math.abs(other.y - this.y) <= within && Math.abs(other.z - this.z) <= within && Math.abs(other.w - this.w) <= within;
    }

    public function toString() {
        return "{" + x + "," + y + "," + z + "," + w + "}";
    }

    public function clone() {
        return new Vector(this.x,this.y,this.w,this.h);
    }

    public function getArray():Array<Float> {
        return [this.x,this.y,this.z,this.w];
    }

    public function getLongestAxis() {
        var arr = getArray();
        var long:Float = -1.0;
        for(i in arr) {
            var abs = Math.abs(i);
            if(Math.abs(abs) > long) {
                long = abs;
            }
        }
        return long;
    }
    public function getShortestAxis() {
        var arr = getArray();
        var short:Float = -1.0;
        for(i in arr) {
            var abs = Math.abs(i);
            if(Math.abs(abs) < short) {
                short = abs;
            }
        }
        return short;
    }
    public static function fromArray(array:Array<Float>) {
        return new Vector(array[0],array[1],array[2],array[3]);
    }

    //Returns vector with biggest getLongestAxis()
    public static function max(array:Array<Vector>) {
        var long = -1;
        var longObj = null;
        for(i in array) {
            var il = i.getLongestAxis();
            if(il > long) {
                long = il;
                longObj = i;
            }
        }
        return longObj;
    }
    //Returns vector with smallest getShortestAxis()
    public static function min(array:Array<Vector>) {
        var short = -1;
        var shortObj = null;
        for(i in array) {
            var il = i.getShortestAxis();
            if(il < short || short == -1) {
                short = il;
                shortObj = i;
            }
        }
        return shortObj;
    }

    //Returns vector with longest distance getMagnitudeFastSquare()
    public static function longest(array:Array<Vector>) {
        var long = -1;
        var longObj = null;
        for(i in array) {
            var il = i.getMagnitudeFastSquare();
            if(il > long) {
                long = il;
                longObj = i;
            }
        }
        return longObj;
    }
    //Returns vector with shortest distance getMagnitudeFastSquare()
    public static function shortest(array:Array<Vector>) {
        var short = -1;
        var shortObj = null;
        for(i in array) {
            var il = i.getMagnitudeFastSquare();
            if(il < short || short == -1) {
                short = il;
                shortObj = i;
            }
        }
        return shortObj;
    }

}