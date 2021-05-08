/*******************************************************************************
 * The MIT License (MIT)
 *
 * Copyright (c) 2021 Jean-David Gadina - www.xs-labs.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 ******************************************************************************/

import Foundation

@objc public class CPUInfo: NSObject
{
    @objc public private( set ) dynamic var name:    String
    @objc public private( set ) dynamic var title:   String
    @objc public private( set ) dynamic var sorting: Int
    
    public static var all: [ Config.Architecture : [ CPUInfo ] ] =
    {
        () -> [ Config.Architecture : [ CPUInfo ] ] in
        
        let archs: [ Config.Architecture ]               = [ .aarch64, .arm, .i386, .x86_64, .ppc, .ppc64, .riscv32, .riscv64, .m68k ]
        var all:   [ Config.Architecture : [ CPUInfo ] ] = [:]
        
        archs.forEach
        {
            all[ $0 ] = QEMU.System.cpus( for: $0 ).map
            {
                CPUInfo( name: $0.0, title: $0.1, sorting: 0 )
            }
        }
        
        return all
    }()
    
    public init( name: String, title: String, sorting: Int )
    {
        self.name    = name
        self.title   = title
        self.sorting = sorting
    }
    
    public override var description: String
    {
        if self.title.count > 0
        {
            return "\( self.name ) - \( self.title )"
        }
        
        return self.name
    }
    
    public override func isEqual( _ object: Any? ) -> Bool
    {
        guard let cpu = object as? CPUInfo else
        {
            return false
        }
        
        return self.name == cpu.name
    }
}
