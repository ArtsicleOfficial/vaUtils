package;

class VAUtils {
    public static function collisionBoxBox(x:Float,y:Float,w:Float,h:Float,x2:Float,y2:Float,w2:Float,h2:Float) {
        return (x+y >= x2 && y+h >= y2 && x2+w2 >= x && y2+h2 >= y);
    }
    public static function collisionCirclePoint(circleX:Float,circleY:Float,circleRadius:Float,pointX:Float,pointY:Float):Bool {
        var offPointX = pointX - circleX;
        var offPointY = pointY - circleY;
        var radSq = circleRadius * circleRadius;
        return ((offPointX * offPointX) + (offPointY * offPointY)) <= radSq;
    }
    //https://www.jeffreythompson.org/collision-detection/circle-circle.php
    public static function collisionCircleCirlce(x:Float, y:Float, r:Float, x2:Float, y2:Float, r2:Float) {

        // get distance between the circle's centers
        // use the Pythagorean Theorem to compute the distance
        var distX = x - x2;
        var distY = y - y2;
        var distance = (distX*distX) + (distY*distY);

        // if the distance is less than the sum of the circle's
        // radii, the circles are touching!
        if (distance <= (r+r2) * (r+r2)) {
            return true;
        }
        return false;
        }
    }
    //https://www.jeffreythompson.org/collision-detection/line-line.php
    //Returns null with no collision. Returns a 2D vector when there is.
    public static function collisionLineLine(x1:Float, y1:Float, x2:Float, y2:Float, x3:Float, y3:Float, x4:Float, y4:Float):Vector {

        // calculate the distance to intersection point
        var uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
        var uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

        // if uA and uB are between 0-1, lines are colliding
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {

            // optionally, draw a circle where the lines meet
            return new Vector(x1 + (uA * (x2-x1)), y1 + (uA * (y2-y1)));
        }
        return null;
    }
    //https://www.jeffreythompson.org/collision-detection/line-rect.php
    //Returns null with no collision. Returns an array of collision points along the rectangle's edges when there is at least one collision.
    public static function collisionLineBox(x1:Float, y1:Float, x2:Float, y2:Float, rx:Float, ry:Float, rw:Float, rh:Float):Array<Vector> {

        // check if the line has hit any of the rectangle's sides
        // uses the Line/Line function below
        var left =   collisionLineLine(x1,y1,x2,y2, rx,ry,rx, ry+rh);
        var right =  collisionLineLine(x1,y1,x2,y2, rx+rw,ry, rx+rw,ry+rh);
        var top =    collisionLineLine(x1,y1,x2,y2, rx,ry, rx+rw,ry);
        var bottom = collisionLineLine(x1,y1,x2,y2, rx,ry+rh, rx+rw,ry+rh);

        // if ANY of the above are true, the line
        // has hit the rectangle
        var out:Array<Vector> = new Array<Vector>();
        if(left != null)
            out.push(left);
        if(top != null)
            out.push(top);
        if(right != null)
            out.push(right);
        if(bottom != null)
            out.push(bottom);
        if(out.length > 0) {
            return out;
        }
        return null;
    }
    public static function lerp(min:Float,max:Float,alpha:Float,operation:VAEasings=null) {
        if(operation == null) {
            operation = Linear;
        }
        switch(operation) {
            case Linear:
            case QuadIn:
                alpha *= alpha;
            case QuadOut:
                alpha = 1 - ((1-alpha)*(1-alpha));
            case QuadInOut:
                alpha = alpha < 0.5 ? (2.0 * alpha * alpha) : (1 - (((-2 * alpha + 2) * (-2 * alpha + 2) / 2)));
        }
        return ((max-min)*alpha) + min;
    }
}