//
//  CategotyProtocol.swift
//  Donmani
//
//  Created by 문종식 on 2/6/25.
//

import Foundation

protocol CategoryProtocol: CaseIterable, RawRepresentable where RawValue: Hashable { }
